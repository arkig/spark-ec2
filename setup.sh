#!/bin/bash

echo -e "\n========== START spark-ec2/setup.sh on `hostname` =========="

# Make sure we are in the spark-ec2 directory
cd /root/spark-ec2

# Load the environment variables specific to this AMI
source /root/.bash_profile

#set -u

# Load the cluster variables set by the deploy script
source ec2-variables.sh

# Always include 'scala' (first), 'rpms' and 'extra' modules (last)
# if not defined as a work around for older versions spark_ec2.py.
if [[ ! $MODULES =~ *scala* ]]; then
  MODULES=$(printf "%s\n%s\n" "scala" $MODULES)
fi
if [[ ! $MODULES =~ *rpms* ]]; then
  MODULES=$(printf "%s\n%s\n" $MODULES "rpms")
fi
if [[ ! $MODULES =~ *extra* ]]; then
  MODULES=$(printf "%s\n%s\n" $MODULES "extra")
fi

# Load any user provided cluster variables or overrides
if [[ -e ec2-user-variables.sh ]]; then
    echo "Found ec2-user-variables.sh, sourcing it."
    source ec2-user-variables.sh
fi

# Set defaults in case these aren't provided in ec2-variables or ec2-user-variables
VERBOSE=${VERBOSE-true}
# Allowing separation of these alows finer control and supports dependencies.
INIT_MODULES=${INIT_MODULES-$MODULES}
SETUP_MODULES=${SETUP_MODULES-$MODULES}
TEST_MODULES=${TEST_MODULES-$MODULES}
RUN_MODULES=${RUN_MODULES-$MODULES}

echo "MODULES=$MODULES"
echo "INIT_MODULES =$INIT_MODULES"
echo "SETUP_MODULES=$SETUP_MODULES"
echo "TEST_MODULES =$TEST_MODULES"
echo "RUN_MODULES  =$RUN_MODULES"


# Set hostname based on EC2 private DNS name, so that it is set correctly
# even if the instance is restarted with a different private DNS name
PRIVATE_DNS=`wget -q -O - http://instance-data.ec2.internal/latest/meta-data/local-hostname`
PUBLIC_DNS=`wget -q -O - http://instance-data.ec2.internal/latest/meta-data/hostname`
hostname $PRIVATE_DNS
echo $PRIVATE_DNS > /etc/hostname
export HOSTNAME=$PRIVATE_DNS  # Fix the bash built-in hostname variable too
echo "Hostname: `hostname`"

# Set up the masters, slaves, etc files based on cluster env variables (used by copy_dir, etc..)
echo "$MASTERS" > masters
echo "$SLAVES" > slaves

MASTERS=`cat masters`
NUM_MASTERS=`cat masters | wc -l`
OTHER_MASTERS=`cat masters | sed '1d'`
SLAVES=`cat slaves`
SSH_OPTS="-o StrictHostKeyChecking=no -o ConnectTimeout=5"

if [[ "x$JAVA_HOME" == "x" ]] ; then
    echo "Expected JAVA_HOME to be set in .bash_profile!"
    exit 1
fi

if [[ `tty` == "not a tty" ]] ; then
    echo "Expecting a tty or pty! (use the ssh -t option)."
    exit 1
fi

echo -e "\n===== Setup ====="

echo "Setting executable permissions on scripts..."
find . -regex "^.+.\(sh\|py\)" | xargs chmod a+x

echo "Running setup-slave on master to mount filesystems, etc..."
./setup-slave.sh

echo -e "\n===== Approving SSH keys ====="

echo "SSH'ing to master machine(s) to approve key(s)..."
for master in $MASTERS; do
  echo "... $master"
  ssh $SSH_OPTS $master echo -n &
  sleep 0.3
done
ssh $SSH_OPTS localhost echo -n &
ssh $SSH_OPTS `hostname` echo -n &
wait

# Try to SSH to each cluster node to approve their key. Since some nodes may
# be slow in starting, we retry failed slaves up to 3 times.
TODO="$SLAVES $OTHER_MASTERS" # List of nodes to try (initially all)
TRIES="0"                          # Number of times we've tried so far
echo "SSH'ing to other cluster nodes to approve keys..."
while [ "e$TODO" != "e" ] && [ $TRIES -lt 4 ] ; do
  NEW_TODO=
  for slave in $TODO; do
    echo "... $slave"
    ssh $SSH_OPTS $slave echo -n
    if [ $? != 0 ] ; then
        NEW_TODO="$NEW_TODO $slave"
    fi
  done
  TRIES=$[$TRIES + 1]
  if [ "e$NEW_TODO" != "e" ] && [ $TRIES -lt 4 ] ; then
      sleep 15
      TODO="$NEW_TODO"
      echo "Re-attempting SSH to cluster nodes to approve keys..."
  else
      break;
  fi
done

echo -e "\n===== Deploying spark-ec2 scripts ====="
# NOTE: We need to rsync spark-ec2 before we can run setup-slave.sh
# on other cluster nodes

echo "RSYNC'ing /root/spark-ec2 to other cluster nodes..."
parallel --quote rsync -e "ssh $SSH_OPTS" -az /root/spark-ec2 {}:/root ::: $SLAVES $OTHER_MASTERS
parallel scp $SSH_OPTS ~/.ssh/id_rsa {}:.ssh ::: $SLAVES $OTHER_MASTERS
# for node in $SLAVES $OTHER_MASTERS; do
#   echo $node
  # rsync -e "ssh $SSH_OPTS" -az /root/spark-ec2 $node:/root &
  # scp $SSH_OPTS ~/.ssh/id_rsa $node:.ssh &
  # sleep 0.3
# done
# wait

echo -e "\n===== Running slave setup on other cluster nodes ====="
for node in $SLAVES $OTHER_MASTERS; do
  echo -e "\n----- Slave setup on $node -----"
  ssh -t -t $SSH_OPTS root@$node "spark-ec2/setup-slave.sh" & sleep 0.3
done
wait

echo -e "\n===== Initializing modules ====="
for module in $INIT_MODULES; do
  if [[ -e $module/init.sh ]]; then
    echo -e "\n----- Initializing $module -----"
    source $module/init.sh
  elif $VERBOSE; then
    echo -e "\n----- Skipping $module -----"
  fi
  cd /root/spark-ec2  # guard against init.sh changing the cwd
done

echo -e "\n===== Creating local config files ====="

# Move configuring templates to a per-module?
./deploy_templates.py

echo -e "\n===== Setting up modules ====="
for module in $SETUP_MODULES; do
  if [[ -e $module/setup.sh ]]; then
    echo -e "\n----- Setting up $module -----"
    source $module/setup.sh
  elif $VERBOSE; then
    echo -e "\n----- Skipping $module -----"
  fi
  cd /root/spark-ec2  # guard against setup.sh changing the cwd
done

echo -e "\n===== Testing modules ====="
for module in $TEST_MODULES; do
  if [[ -e $module/test.sh ]]; then
    echo -e "\n----- Testing $module -----"
    source $module/test.sh
  elif $VERBOSE; then
    echo -e "\n----- Skipping $module -----"
  fi
  cd /root/spark-ec2  # guard against setup.sh changing the cwd
done

echo -e "\n===== Running modules ====="
for module in $RUN_MODULES; do
  if [[ -e $module/run.sh ]]; then
    echo -e "\n----- Running $module -----"
    source $module/run.sh
  elif $VERBOSE; then
    echo -e "\n----- Skipping $module -----"
  fi
  cd /root/spark-ec2  # guard against setup.sh changing the cwd
done

echo -e "\n========== Nodes =========="
echo "MASTERS:"
echo "$MASTERS"
echo ""
echo "SLAVES:"
echo "$SLAVES"

echo -e "\n========== Services =========="
MASTER=`cat masters | head -n1`
echo "Spark Master:  http://$MASTER:8080"
echo "Spark Jobs:    http://$MASTER:4040/jobs/"
echo "Tachyon:       http://$MASTER:19999"
echo "HDFS Namenode: http://$MASTER:50070"
echo "Ganglia:       http://$MASTER:5080/ganglia"

echo ""
HDFS_NFS_MOUNT="/hdfs_nfs"  # Ideally would include cluster name, but that's not available here. TODO
echo "HDFS NFS Gateway: sudo mkdir -p $HDFS_NFS_MOUNT &&"
echo "                  sudo mount -t nfs -o vers=3,proto=tcp,nolock,rsize=1048576,wsize=65536,timeo=600 $MASTER:/ $HDFS_NFS_MOUNT"
echo "                  sudo umount -f $HDFS_NFS_MOUNT"

echo -e "\n========== END spark-ec2/setup.sh on `hostname` =========="
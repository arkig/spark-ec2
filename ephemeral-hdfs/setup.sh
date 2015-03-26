#!/bin/sh

EPHEMERAL_HDFS=/root/ephemeral-hdfs

pushd /root/spark-ec2/ephemeral-hdfs

# Just in case it's running
$EPHEMERAL_HDFS/sbin/stop-dfs.sh

#TODO PUBLIC_DNS appears to be broken

# Set hdfs url to make it easier
HDFS_URL="hdfs://$PUBLIC_DNS:9000"
echo "export HDFS_URL=$HDFS_URL" >> ~/.bash_profile

echo "Adding ephemeral HDFS bin and sbin to PATH on master..."
# so easy to interact with ephemeral hdfs on master
echo "export EPHEMERAL_HDFS=$EPHEMERAL_HDFS" >> ~/.bash_profile
echo "export PATH=\$PATH:\$EPHEMERAL_HDFS/bin:\$EPHEMERAL_HDFS/sbin" >> ~/.bash_profile

source ~/.bash_profile

echo "Adding ephemeral HDFS bin to PATH on other cluster nodes..."
# so can use hdfs tools, etc on nodes.
RCMD="echo \"export PATH=\\\$PATH:"$EPHEMERAL_HDFS"/bin\" >> ~/.bash_profile"
for node in $SLAVES $OTHER_MASTERS; do
  echo "... $node"
  ssh -t $SSH_OPTS root@$node $RCMD
done
wait

echo "Running ephemeral HDFS setup-slave on master..."
source ./setup-slave.sh

echo "Running ephemeral HDFS setup-slave on other cluster nodes..."
for node in $SLAVES $OTHER_MASTERS; do
  echo "... $node"
  ssh -t -t $SSH_OPTS root@$node "/root/spark-ec2/ephemeral-hdfs/setup-slave.sh" & sleep 0.3
done
wait

echo "Deploying ephemeral-hdfs config files..."
/root/spark-ec2/copy-dir $EPHEMERAL_HDFS/conf

NAMENODE_DIR=/mnt/ephemeral-hdfs/dfs/name

if [ -f "$NAMENODE_DIR/current/VERSION" ] && [ -f "$NAMENODE_DIR/current/fsimage" ]; then
  echo "Hadoop namenode appears to be formatted: skipping"
else
  echo "Formatting ephemeral HDFS namenode..."
  #$EPHEMERAL_HDFS/bin/hadoop namenode -format
  #DEPRECATED: Use of this script to execute hdfs command is deprecated.
  # So....
  $EPHEMERAL_HDFS/bin/hdfs namenode -format
fi


echo "Starting ephemeral HDFS..."
# This is different depending on version. Simple hack: just try both.
$EPHEMERAL_HDFS/sbin/start-dfs.sh
#$EPHEMERAL_HDFS/bin/start-dfs.sh

sleep 2

# Note: doing this after starting hdfs. Will fail otherwise.
# add usernames
$EPHEMERAL_HDFS/bin/hdfs dfs -mkdir /user
$EPHEMERAL_HDFS/bin/hdfs dfs -mkdir /user/root

sleep 1

popd

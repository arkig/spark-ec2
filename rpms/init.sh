#!/bin/sh
#
# Install and initialise any arbitrary rpms that the spark_ec2.py script has scp'd here.

if [ -d /root/rpms ]; then

  echo "Installing RPMs..."
  sudo rpm -Uvh /root/rpms/*.rpm

  # Don't do this if we're running this as part of image creation.
  if [ -d "/root/spark-ec2" ]; then

    echo "RSYNC'ing /root/rpms to other cluster nodes..."
    parallel --quote rsync -e "ssh $SSH_OPTS" -az /root/rpms {}:/root ::: $SLAVES $OTHER_MASTERS

    echo "Installing RPMs on other cluster nodes..."
    for node in $SLAVES $OTHER_MASTERS; do
      echo -e "\n... Installing rpms on $node"
      ssh -t -t $SSH_OPTS root@$node "sudo rpm -Uvh /root/rpms/*.rpm" & sleep 0.3
    done
    wait
  fi

  if [[ -e /root/rpms/init.sh ]]; then

    echo "Initialising RPMs with root/rpms/init.sh..."
    /root/rpms/init.sh

    # Don't do this if we're running this as part of image creation.
    if [ -d "/root/spark-ec2" ]; then
      echo "Initialising RPMs on other cluster nodes..."
      for node in $SLAVES $OTHER_MASTERS; do
        echo -e "\n... rpms/init.sh on $node"
        ssh -t -t $SSH_OPTS root@$node "/root/rpms/init.sh"
      done
      wait
    fi

  else
    echo "No root/rpms/init.sh provided."
  fi

fi

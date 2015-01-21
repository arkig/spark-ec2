#!/bin/bash

PERSISTENT_HDFS=/root/persistent-hdfs

pushd /root/spark-ec2/persistent-hdfs

echo "Running persistent HDFS setup-slave on master..."
source ./setup-slave.sh

echo "Running persistent HDFS setup-slave on other cluster nodes..."
for node in $SLAVES $OTHER_MASTERS; do
  echo "... $node"
  ssh -t $SSH_OPTS root@$node "/root/spark-ec2/persistent-hdfs/setup-slave.sh" & sleep 0.3
done
wait

echo "Deploying persistent-hdfs config files..."
/root/spark-ec2/copy-dir $PERSISTENT_HDFS/conf

if [[ ! -e /vol/persistent-hdfs/dfs/name ]] ; then
  echo "Formatting persistent HDFS namenode..."
  #$PERSISTENT_HDFS/bin/hadoop namenode -format
  $PERSISTENT_HDFS/bin/hdfs namenode -format
fi

# Must do this after starting hdfs
# add usernames
#$PERSISTENT_HDFS/bin/hdfs dfs -mkdir /user
#$PERSISTENT_HDFS/bin/hdfs dfs -mkdir /user/root

echo "Persistent HDFS installed, won't start by default..."

popd

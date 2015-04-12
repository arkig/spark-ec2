#!/bin/sh


#TODO
# Get fuse-dfs working. Seems to be built.
# http://www.linuxquestions.org/questions/linux-newbie-8/unable-to-load-libjvm-so-4175455996/
# /tmp/hadoop-2.4.1-src/hadoop-hdfs-project/hadoop-hdfs/target/native/main/native/fuse-dfs/
# above is not built though!
# /tmp/hadoop-2.4.1-src/hadoop-hdfs-project/hadoop-hdfs/src/main/native/fuse-dfs/fuse_dfs_wrapper.sh
# hadoop-native/lib has other .so files that are needed.. modify LD_LIBRARY_PATH
# also need to modify LD_LIBRARY_PATH for libjvm in java setup.

# http://wiki.apache.org/hadoop/MountableHDFS

SERVER=$(hostname)
PORT="9000"

DFS_MOUNT="/fuse_dfs"

# Note: rsize and wsize based on dfs.nfs.rtmax and dfs.nfs.wtmax hadoop properties
MNT_CMD="sudo mkdir -p $DFS_MOUNT && /root/fuse-dfs/fuse_dfs_wrapper.sh dfs://$SERVER:$PORT $DFS_MOUNT"

# TODO tail -n dump of syslog

echo "Mounting HDFS using fuse_dfs (running on $SERVER) on master..."
eval "$MNT_CMD"

echo "Mounting HDFS using fuse_dfs (running on $SERVER) on other cluster nodes..."
for node in $SLAVES $OTHER_MASTERS; do
  echo "... $node"
  ssh -t $SSH_OPTS root@$node "$MNT_CMD"
done
wait

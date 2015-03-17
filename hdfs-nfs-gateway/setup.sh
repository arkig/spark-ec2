#!/bin/sh
#
# Set up HDFS NFS ganeway for the primary HDFS.

# See http://hadoop.apache.org/docs/r2.4.0/hadoop-project-dist/hadoop-hdfs/HdfsNfsGateway.html

# Stop anything that might be running
hadoop-daemon.sh stop nfs3
hadoop-daemon.sh stop portmap

# Restart:

# Stop nfs/rpcbind/portmap services provided by the platform
service nfs stop
service rpcbind stop

# Start package included portmap (needs root privileges):
#hadoop portmap
hadoop-daemon.sh start portmap

# Start mountd and nfsd.
# No root privileges are required for this command. However, ensure that the user starting the Hadoop cluster and the user starting the NFS gateway are same.
#hadoop nfs3
hadoop-daemon.sh start nfs3

sleep 2

# Mount everywhere

# Note: rsize and wsize based on dfs.nfs.rtmax and dfs.nfs.wtmax hadoop properties
MNT_CMD="sudo mkdir -p /hdfs_nfs & sudo mount -t nfs -o vers=3,proto=tcp,nolock,rsize=1048576,wsize=65536 $MASTER:/  /hdfs_nfs"

echo "Mounting HDFS NFS on master..."
$MNT_CMD

echo "Mounting HDFS NFS on other cluster nodes..."
for node in $SLAVES $OTHER_MASTERS; do
  echo "... $node"
  ssh -t -t $SSH_OPTS root@$node $MNT_CMD & sleep 0.3
done
wait

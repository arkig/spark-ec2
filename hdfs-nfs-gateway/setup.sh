#!/bin/sh
#
# Set up HDFS NFS gateway for the primary HDFS (bin and sbin for that HDFS must be on path).
#
# See http://hadoop.apache.org/docs/r2.4.0/hadoop-project-dist/hadoop-hdfs/HdfsNfsGateway.html

echo "Setting up hdfs-nfs gateway for this hdfs: $(which hadoop)"

HADOOP_DAEMON=$(which hadoop-daemon.sh)

# Stop anything that might be running
sudo $HADOOP_DAEMON stop nfs3
sudo $HADOOP_DAEMON stop portmap

# Restart
# -------

# Stop nfs/rpcbind/portmap services provided by the platform
sudo service nfs stop
sudo service rpcbind stop

# Start package included portmap (needs root privileges):
#sudo hadoop portmap
sudo $HADOOP_DAEMON start portmap

# Start mountd and nfsd.
# No root privileges are required for this command. However, ensure that the user starting the
# Hadoop cluster and the user starting the NFS gateway are same.
#hadoop nfs3
$HADOOP_DAEMON start nfs3

sleep 2

# Mount everywhere
# ----------------

# Can't use MASTER, as that's public facing.
# We know that namenode (and this script) is running on master. So:
SERVER=$(hostname)

HDFS_NFS_MOUNT="/hdfs_nfs"

# Note: rsize and wsize based on dfs.nfs.rtmax and dfs.nfs.wtmax hadoop properties
MNT_CMD="sudo mkdir -p $HDFS_NFS_MOUNT && sudo mount -t nfs -o vers=3,proto=tcp,nolock,rsize=1048576,wsize=65536 $SERVER:/ $HDFS_NFS_MOUNT"

echo "Mounting HDFS NFS (which is running on $SERVER) on master..."
eval "$MNT_CMD"

echo "Mounting HDFS NFS (which is running on $SERVER) on other cluster nodes..."
for node in $SLAVES $OTHER_MASTERS; do
  echo "... $node"
  ssh -t $SSH_OPTS root@$node "$MNT_CMD"
done
wait

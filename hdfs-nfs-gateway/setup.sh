#!/bin/sh
#
# Set up HDFS NFS gateway for the primary HDFS.
# (bin and sbin for that HDFS must be on path)
#
# See http://hadoop.apache.org/docs/r2.4.0/hadoop-project-dist/hadoop-hdfs/HdfsNfsGateway.html

# Stop anything that might be running
sudo hadoop-daemon.sh stop nfs3
sudo hadoop-daemon.sh stop portmap

# Restart
# -------

# Stop nfs/rpcbind/portmap services provided by the platform
sudo service nfs stop
sudo service rpcbind stop

# Start package included portmap (needs root privileges):
#sudo hadoop portmap
sudo hadoop-daemon.sh start portmap

# Start mountd and nfsd.
# No root privileges are required for this command. However, ensure that the user starting the
# Hadoop cluster and the user starting the NFS gateway are same.
#hadoop nfs3
hadoop-daemon.sh start nfs3

sleep 2

# Mount everywhere
# ----------------

# Can't use MASTER, as that's public facing.
# We know that namenode (and this script) is running on master. So:
SERVER=$(hostname)

# Note: rsize and wsize based on dfs.nfs.rtmax and dfs.nfs.wtmax hadoop properties
MNT_CMD="sudo mount -t nfs -o vers=3,proto=tcp,nolock,rsize=1048576,wsize=65536 $SERVER:/  /hdfs_nfs"

echo "Mounting HDFS NFS (running on $SERVER) on master..."
sudo mkdir -p /hdfs_nfs
$MNT_CMD

echo "Mounting HDFS NFS (running on $SERVER) on other cluster nodes..."
for node in $SLAVES $OTHER_MASTERS; do
  echo "... $node"
  ssh -t -t $SSH_OPTS root@$node "sudo mkdir -p /hdfs_nfs" & "$MNT_CMD" & sleep 0.1
done
wait

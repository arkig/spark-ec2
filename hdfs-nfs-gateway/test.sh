#!/bin/sh

nfs_server_ip=$(hostname)

echo "rpcinfo for $nfs_server_ip:"
rpcinfo -p $nfs_server_ip

echo "Show HDFS-NFS mount:"
showmount -e $nfs_server_ip

echo "mount:"
mount
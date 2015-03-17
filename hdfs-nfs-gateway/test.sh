#!/bin/sh

nfs_server_ip=$MASTER

rpcinfo -p $nfs_server_ip

showmount -e $nfs_server_ip

mount
#!/bin/bash

/root/spark-ec2/copy-dir /root/tachyon

/root/tachyon/bin/tachyon format

#TODO
#Formatting Tachyon Master @ ec2-54-206-35-187.ap-southeast-2.compute.amazonaws.com
#Formatting JOURNAL_FOLDER: /root/tachyon/libexec/../journal/
#Exception in thread "main" java.lang.RuntimeException: org.apache.hadoop.ipc.RemoteException: Server IPC version 7 cannot communicate with client version 4
#	at tachyon.util.CommonUtils.runtimeException(CommonUtils.java:246)
#	at tachyon.UnderFileSystemHdfs.<init>(UnderFileSystemHdfs.java:73)
#	at tachyon.UnderFileSystemHdfs.getClient(UnderFileSystemHdfs.java:53)
#	at tachyon.UnderFileSystem.get(UnderFileSystem.java:53)
#	at tachyon.Format.main(Format.java:54)
#Caused by: org.apache.hadoop.ipc.RemoteException: Server IPC version 7 cannot communicate with client version 4
#	at org.apache.hadoop.ipc.Client.call(Client.java:1070)
#	at org.apache.hadoop.ipc.RPC$Invoker.invoke(RPC.java:225)
#	at com.sun.proxy.$Proxy1.getProtocolVersion(Unknown Source)
#	at org.apache.hadoop.ipc.RPC.getProxy(RPC.java:396)
#	at org.apache.hadoop.ipc.RPC.getProxy(RPC.java:379)
#	at org.apache.hadoop.hdfs.DFSClient.createRPCNamenode(DFSClient.java:119)
#	at org.apache.hadoop.hdfs.DFSClient.<init>(DFSClient.java:238)
#	at org.apache.hadoop.hdfs.DFSClient.<init>(DFSClient.java:203)
#	at org.apache.hadoop.hdfs.DistributedFileSystem.initialize(DistributedFileSystem.java:89)
#	at org.apache.hadoop.fs.FileSystem.createFileSystem(FileSystem.java:1386)
#	at org.apache.hadoop.fs.FileSystem.access$200(FileSystem.java:66)
#	at org.apache.hadoop.fs.FileSystem$Cache.get(FileSystem.java:1404)
#	at org.apache.hadoop.fs.FileSystem.get(FileSystem.java:254)
#	at org.apache.hadoop.fs.Path.getFileSystem(Path.java:187)
#	at tachyon.UnderFileSystemHdfs.<init>(UnderFileSystemHdfs.java:69)
#	... 3 more
#Killed 0 processes
#Killed 0 processes
#ec2-54-206-36-2.ap-southeast-2.compute.amazonaws.com: Killed 0 processes
#Starting master @ ec2-54-206-35-187.ap-southeast-2.compute.amazonaws.com
#ec2-54-206-36-2.ap-southeast-2.compute.amazonaws.com: TACHYON_LOGS_DIR: /root/tachyon/libexec/../logs
#ec2-54-206-36-2.ap-southeast-2.compute.amazonaws.com: Formatting RamFS: /mnt/ramdisk (2341mb)
#ec2-54-206-36-2.ap-southeast-2.compute.amazonaws.com: Starting worker @ ip-172-31-16-90


sleep 1

/root/tachyon/bin/tachyon-start.sh all Mount

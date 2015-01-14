#!/bin/bash

/root/spark-ec2/copy-dir /etc/ganglia/

# Start gmond everywhere
/etc/init.d/gmond restart

for node in $SLAVES $OTHER_MASTERS; do
  ssh -t -t $SSH_OPTS root@$node "/etc/init.d/gmond restart"
done

# gmeta needs rrds to be owned by nobody
chown -R nobody /var/lib/ganglia/rrds

# Had to add this, as not exists, for below..
mkdir /var/lib/ganglia/conf
# cluster-wide aggregates only show up with this. TODO: Fix this cleanly ?
ln -s /usr/share/ganglia/conf/default.json /var/lib/ganglia/conf/

/etc/init.d/gmetad restart

# Start http server to serve ganglia
/etc/init.d/httpd restart


# ganglia version 3. something is running, but conf appeas to be for 2.5?

#Setting up ganglia
#RSYNC'ing /etc/ganglia to slaves...
#ec2-54-206-36-2.ap-southeast-2.compute.amazonaws.com
#Shutting down GANGLIA gmond:                               [FAILED]
#Starting GANGLIA gmond: no such option 'host_tmax'
#Parse error for '/etc/ganglia/gmond.conf'
#
#                                                           [FAILED]
#Shutting down GANGLIA gmond:                               [FAILED]
#Starting GANGLIA gmond: no such option 'host_tmax'
#Parse error for '/etc/ganglia/gmond.conf'
#
#                                                           [FAILED]
#Connection to ec2-54-206-36-2.ap-southeast-2.compute.amazonaws.com closed.
#ln: target `/var/lib/ganglia/conf/' is not a directory: No such file or directory
#Shutting down GANGLIA gmetad:                              [FAILED]
#Starting GANGLIA gmetad:                                   [  OK  ]
#Stopping httpd:                                            [FAILED]
#Starting httpd: (13)Permission denied: make_sock: could not bind to address [::]:5080
#(13)Permission denied: make_sock: could not bind to address 0.0.0.0:5080
#no listening sockets available, shutting down
#Unable to open logs
#                                                           [FAILED]
#Connection to ec2-54-206-35-187.ap-southeast-2.compute.amazonaws.com closed.

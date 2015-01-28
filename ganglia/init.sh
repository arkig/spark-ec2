#!/bin/sh

# Note: It is assumed that ganglia and dependencies are installed

# NOTE: Remove all rrds which might be around from an earlier run
rm -rf /var/lib/ganglia/rrds/*
rm -rf /mnt/ganglia/rrds/*

# Make sure rrd storage directory has right permissions
mkdir -p /mnt/ganglia/rrds
chown -R ganglia:ganglia /mnt/ganglia/rrds

# Symlink /var/lib/ganglia/rrds to /mnt/ganglia/rrds
rmdir /var/lib/ganglia/rrds
ln -s /mnt/ganglia/rrds /var/lib/ganglia/rrds

# Note that we're using the default httpd.conf, which works fine.
# Just change the default listening port from 80
# Obviously only need to do this on master.
sudo sed -i 's/^Listen .*/Listen 5080/g' /etc/httpd/conf/httpd.conf


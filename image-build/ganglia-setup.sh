#!/bin/sh

# Notes:
# - http://www.metamul.com/blog/using-ganglia-within-ec2/

set -e
set -x
set -u

#sudo yum install -y ganglia ganglia-gmond ganglia-gmetad ganglia-web
sudo yum install -y rrdtool ganglia ganglia-gmetad ganglia-gmond ganglia-web httpd php
# apr apr-util

# Generate a default conf file.
# Not used by the automated setup, but it's there for you to modify and add to spark-ec2 templates
mkdir -p /root/templates/ganglia/
gmond -t | tee /root/templates/ganglia/gmond.conf
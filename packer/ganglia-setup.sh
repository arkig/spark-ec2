#!/bin/sh

# Notes:
# - http://www.metamul.com/blog/using-ganglia-within-ec2/

sudo yum install -y ganglia ganglia-web ganglia-gmond ganglia-gmetad


# Generate a default conf file.
# Not used by the automated setup, but it's there for you to modify and add to spark-ec2 templates
mkdir -p /root/templates/ganglia/
gmond -t | tee /root/templates/ganglia/gmond.conf
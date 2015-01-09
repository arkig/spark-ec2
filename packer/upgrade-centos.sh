#!/bin/bash

set -e

# Upgrade CentOS minimal install to a basic server
# See: http://wiki.centos.org/FAQ/CentOS6
sudo yum groupinstall -y base console-internet core debugging directory-client hardware-monitoring java-platform large-systems network-file-system-client performance perl-runtime server-platform

# Add EPEL repo (will need things from this later)
cd /tmp
sudo wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo rpm -ivh epel-release-6-8.noarch.rpm

# Seems not to be present on CentOS AMI
# Will create /etc/cloud/cloud.cfg etc.
yum install -y cloud-init

rm -rf /tmp/*


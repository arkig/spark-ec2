#!/bin/bash

set -e

sudo debuginfo-install -q -y kernel

# sudo yum update -y  # this can be problematic
sudo yum update -y --security  # security udpates only

sudo yum install -y pssh git
sudo yum install -y ganglia ganglia-web ganglia-gmond ganglia-gmetad
sudo yum install -y xfsprogs

# Perf tools
sudo yum install -y dstat iotop strace sysstat htop perf


# why need this??
#pushd /etc/yum.repos.d/
#sudo wget http://download.opensuse.org/repositories/home:tange/CentOS_CentOS-5/home:tange.repo
#sudo yum install -y parallel
#echo "will cite" | parallel --bibtex
#popd



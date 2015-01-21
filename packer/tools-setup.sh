#!/bin/bash

source ./image_variables.sh

set -e

sudo debuginfo-install -q -y kernel

sudo yum install -y pssh git

sudo yum install -y xfsprogs

# Development tools
sudo yum groupinstall -y "Development tools"
sudo yum install -y gcc gcc-c++
# The following are required by python installation/libraries + some are needed for other things
sudo yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel

# For connection debugging
# nc?
sudo yum install -y telnet

# Perf tools
sudo yum install -y dstat iotop strace sysstat htop perf

# Modify prompt
echo "export PS1=\"\\u@\\h \\W]\\$ \"" >> ~/.bash_profile


# Install GNU Parallel
# - used to speed up copying to slaves in cluster setup, etc.
cd /tmp
wget http://ftpmirror.gnu.org/parallel/parallel-${PARALLEL_VERSION}.tar.bz2
bzip2 -dc parallel-${PARALLEL_VERSION}.tar.bz2 | tar xvf -
cd parallel-${PARALLEL_VERSION}
./configure
make
sudo make install
echo "will cite" | parallel --bibtex


#!/bin/sh

set -e
set -x
set -u

sudo debuginfo-install -q -y kernel

# Development tools (most should be installed by now)
sudo yum install -y gcc gcc-c++ git

# The following are required by python installation/libraries + some are needed for other things, so lets put them here.
sudo yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel

# Doesn't work - can't find packages
#sudo yum-complete-transaction
#sudo debuginfo-install -q -y glibc

# Parallel ssh
sudo yum install -y pssh

# For connection debugging
sudo yum install -y telnet

# XFS filesystem admin and debugging (needed??)
sudo yum install -y xfsprogs

# Perf tools
sudo yum install -y dstat iotop strace sysstat htop perf

# Modify prompt
echo "export PS1=\"\\u@\\h \\W]\\$ \"" >> ~/.bash_profile

# Required because various install-from-source that we do will install here (e.g. parallel, etc)
echo "export PATH=$PATH:/usr/local/bin" >> ~/.bash_profile
set +u
source ~/.bash_profile
set -u

# Install GNU Parallel
# - used to speed up copying to slaves in cluster setup, etc.
cd /tmp
wget http://ftpmirror.gnu.org/parallel/parallel-${PARALLEL_VERSION}.tar.bz2
bzip2 -dc parallel-${PARALLEL_VERSION}.tar.bz2 | tar xvf -
rm -f parallel-${PARALLEL_VERSION}.tar.bz2
cd parallel-${PARALLEL_VERSION}
./configure
make
sudo make install
cd /tmp
rm -rf parallel-${PARALLEL_VERSION}
echo "will cite" | parallel --bibtex


#!/bin/sh

sudo yum install -y ntp ntpdate libselinux-python net-snmp wget at vim dmidecode man-pages man

# C++ dependencies
# Previous steps seem to get all these
sudo yum install -y zlib libpcap glibc bzip2-libs xz-libs boost-regex

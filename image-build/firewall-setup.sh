#!/bin/sh

# Notes:
# - Spark uses random ports
# - CentOS iptables by default is quite locked down
# - Rely on AWS security groups, so turn iptables off
# - selinux causes too many problems, so turn it off. Note that Amazon linux doesn't have it installed at all.
#
# Notes
# - selinux ignoring conf issue: https://www.centos.org/forums/viewtopic.php?f=17&t=45982

set -e
set -x
set -u

# Stop..
sudo /etc/init.d/iptables stop
# and stop it from running on reboot
sudo chkconfig iptables off

# Turn off SELinux...
sudo setenforce 0
# and make it permanent
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
# Note: /etc/sysconfig/selinux has a symlink to the above

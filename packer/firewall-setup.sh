#!/bin/sh

# Notes:
# - Spark uses random ports
# - CentOS by default is quite locked down
# - Rely on AWS security groups, so turn iptables off

# Stop..
sudo /etc/init.d/iptables stop
# and stop it from running on reboot
sudo chkconfig iptables off

# Turn off SELinux...
sudo setenforce 0
# and make it permanent
sudo sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux


#!/bin/sh

# Notes:
# - Spark uses random ports
# - CentOS by default is quite locked down
# - Rely on AWS security groups, so turn iptables off

# Stop..
sudo /etc/init.d/iptables stop

# and stop it from running on reboot
sudo chkconfig iptables off
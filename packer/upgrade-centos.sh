#!/bin/sh
#
# Upgrade CentOS with basic prerequisites and ensure we can log in as root.

set -e
set -x
set -u

if [ -n "$(command -v wget)" ]; then

    echo "Warning: Assuming image has already had this script applied!"

else
    sudo yum install -y wget

    # Add EPEL repo (will need things from this later)
    cd /tmp
    wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
    sudo rpm -ivh epel-release-6-8.noarch.rpm
    rm epel-release-6-8.noarch.rpm

    # Upgrade CentOS minimal install to a Basic Server
    # See: http://wiki.centos.org/FAQ/CentOS6
    # All:
    #  base console-internet core debugging directory-client hardware-monitoring java-platform large-systems network-file-system-client performance perl-runtime server-platform
    # Leave out:
    #  - java-platform as will install later
    sudo yum groupinstall -y base console-internet core debugging directory-client hardware-monitoring large-systems network-file-system-client performance perl-runtime server-platform

    # Basic development tools
    sudo yum groupinstall -y "Development tools"

    # Seems not to be present on CentOS AMI
    # Will create /etc/cloud/cloud.cfg etc.
    yum install -y cloud-init

    # Enable root login (if not already)
    sudo sed -i 's/PermitRootLogin.*/PermitRootLogin without-password/g' /etc/ssh/sshd_config

    # ... must enable at cloud.cfg level too
    sudo sed -i 's/disable_root.*/disable_root: 0/g' /etc/cloud/cloud.cfg

fi

# Security udpates only
sudo yum update -y --security


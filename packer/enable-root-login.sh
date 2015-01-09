#!/bin/bash

# Don't think I need this when building on a centos AMI, as appears to be done already
#sudo sed --in-place -r "0,/^\#PermitRootLogin/s/^\#(PermitRootLogin) (.*)/\1 without-password/g" /etc/ssh/sshd_config
# From create_image.sh:
#sudo sed -i 's/PermitRootLogin.*/PermitRootLogin without-password/g' /etc/ssh/sshd_config

# Doesn't seem to work, as 0 1 used rather than true false. So used below...
#sudo sed --in-place -r "s/(^disable_root:) (true)/\1 false/g" /etc/cloud/cloud.cfg
# From create_image.sh:
sudo sed -i 's/disable_root.*/disable_root: 0/g' /etc/cloud/cloud.cfg

#!/bin/sh

set -e
set -x
set -u

# Set up ephemeral mounts
sudo sed -i 's/mounts.*//g' /etc/cloud/cloud.cfg
sudo sed -i 's/.*ephemeral.*//g' /etc/cloud/cloud.cfg
sudo sed -i 's/.*swap.*//g' /etc/cloud/cloud.cfg

echo "mounts:" >> /etc/cloud/cloud.cfg
echo " - [ ephemeral0, /mnt, auto, \"defaults,noatime,nodiratime\", "\
  "\"0\", \"0\" ]" >> /etc/cloud.cloud.cfg

for x in {1..23}; do
  echo " - [ ephemeral$x, /mnt$((x + 1)), auto, "\
    "\"defaults,noatime,nodiratime\", \"0\", \"0\" ]" >> /etc/cloud/cloud.cfg
done

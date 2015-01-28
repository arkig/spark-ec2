#!/bin/sh
#
# Perform module initialisation of some modules on the image, so that these steps can be skipped at cluster deployment time.
#
# Note: The init.sh scripts should guard against running copy-dir.sh when called from here. Since
# /root/spark-ec2/ doen't exist on the image now (gets placed there at cluster build time),
# checking for it is a good way to achieve this.
#
# Note: Packer must have uploaded spark-ec2 for this to work

set -e
set -x
set -u

BASE_DIR="/tmp/spark-ec2"
CWD=$(pwd)

set +u
source ~/.bash_profile
set -u

for module in $IMAGE_MODULES; do
  echo -e "\n----- Initializing $module -----"
  if [[ -e $BASE_DIR/$module/init.sh ]]; then
    source $BASE_DIR/$module/init.sh
  else
    echo "nothing to do"
  fi
  cd $CWD  # guard against init.sh changing the cwd
done

# Clean up
rm -rf /tmp/*



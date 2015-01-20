#!/bin/sh

# Perform module initialisation of some modules on the image, so that these steps can be skipped at cluster deployment time.
# Note: ganglia left out as unsure whether reliance on mount setups
MODULES="scala spark ephemeral-hdfs persistent-hdfs mapreduce spark-standalone tachyon"

# The init.sh scripts should guard against running copy-dir.sh when called from here. Since
# /root/spark-ec2/ doen't exist at this point, checking for it is a good way to achieve this.

cd /root/spark-ec2

# Install / Init module
for module in $MODULES; do
  echo "Initializing $module"
  if [[ -e $module/init.sh ]]; then
    source $module/init.sh
  fi
  cd /root/spark-ec2  # guard against init.sh changing the cwd
done

# Clean up
rm -rf /tmp/*

cd /root/spark-ec2/packer


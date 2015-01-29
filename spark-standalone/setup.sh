#!/bin/sh
#
# Launch spark in standalone mode.
# NOTE: Assumes spark and tachyon have been set ap already


BIN_FOLDER="/root/spark/sbin"
if [[ "0.7.3 0.8.0 0.8.1" =~ $SPARK_VERSION ]]; then
  BIN_FOLDER="/root/spark/bin"
fi

# Set cluster-url to standalone master
echo "spark://""`cat /root/spark-ec2/masters`"":7077" > /root/spark-ec2/cluster-url

# Symlink the work directory to a local disk to avoid EBS volume filling up
mkdir -p /mnt/spark/work
ln -s /mnt/spark/work /root/spark/work

# The Spark master seems to take time to start and workers crash if
# they start before the master. So start the master first, sleep and then start
# workers.

echo "Stop anything that is running..."
$BIN_FOLDER/stop-all.sh

sleep 2

echo "Start master..."
$BIN_FOLDER/start-master.sh

# Pause
sleep 20

echo "Start workers..."
$BIN_FOLDER/start-slaves.sh

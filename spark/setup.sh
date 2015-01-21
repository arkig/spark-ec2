#!/bin/bash

# We no longer have to copy entire /root/spark here as it's now done in init.sh

echo "Deploying Spark config files..."
chmod u+x /root/spark/conf/spark-env.sh
/root/spark-ec2/copy-dir /root/spark/conf

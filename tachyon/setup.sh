#!/bin/sh

echo "Deploying Tachyon config files..."
/root/spark-ec2/copy-dir /root/tachyon/conf

/root/tachyon/bin/tachyon format

sleep 1

/root/tachyon/bin/tachyon-start.sh all Mount

#!/bin/bash

pushd /root

if [ -d "scala" ]; then
  echo "Scala seems to be installed. Exiting."
  return 0
fi

SCALA_VERSION="2.10.3"

if [[ "0.7.3 0.8.0 0.8.1" =~ $SPARK_VERSION ]]; then
  SCALA_VERSION="2.9.3"
fi

echo "Unpacking Scala"
wget http://s3.amazonaws.com/spark-related-packages/scala-$SCALA_VERSION.tgz
tar xvzf scala-*.tgz > /tmp/spark-ec2_scala.log
rm -f scala-*.tgz
mv `ls -d scala-* | grep -v ec2` scala

# Don't copy-dir if we're running this as part of image creation.
if [ -d "/root/spark-ec2" ]; then
    /root/spark-ec2/copy-dir /root/scala
fi

popd

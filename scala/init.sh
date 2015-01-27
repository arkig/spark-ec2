#!/bin/sh

pushd /root

if [ -d "scala" ]; then
  echo "Scala seems to be installed. Exiting."
  return 0
fi

SCALA_VERSION=${SCALA_VERSION-"2.10.3"}

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

#!/bin/sh

pushd /root

if [ -d "hadoop" ]; then
  echo "Hadoop seems to be installed. Exiting."
  return 0
fi

# TODO ensure set
#${HADOOP_VERSION:?}
HADOOP_VERSION=${HADOOP_VERSION-"2.4.1"}

echo "Getting pre-packaged Hadoop $HADOOP_VERSION"

wget http://s3.amazonaws.com/spark-related-packages/hadoop-${HADOOP_VERSION}.tar.gz

echo "Unpacking Hadoop"
tar xvzf hadoop-*.tar.gz > /tmp/spark-ec2_hadoop.log
rm -f hadoop-*.tar.gz
mv `ls -d hadoop-*` hadoop

if [ -d "hadoop-native" ]; then
  echo "Hadoop native libs seem to be installed. Using them."
  # NOTE: Assumes this is version compatible!!!
  cp /root/hadoop-native/* /root/hadoop/lib/native/
fi

popd
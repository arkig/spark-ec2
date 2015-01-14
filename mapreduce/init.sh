#!/bin/bash

pushd /root

if [ -d "mapreduce" ]; then
  echo "Map reduce seems to be installed. Exiting."
  return 0
fi

if [ -d "hadoop" ]; then
  echo "Hadoop build exists on image, using it. Details:"
  hadoop/bin/hadoop version

  cp hadoop/ mapreduce/

  # Have single conf dir
  rm -rf /root/mapreduce/etc/hadoop/
  ln -s /root/mapreduce/conf /root/mapreduce/etc/hadoop

else

    case "$HADOOP_MAJOR_VERSION" in
      1)
        echo "Nothing to initialize for MapReduce in Hadoop 1"
        ;;
      2)
        wget http://s3.amazonaws.com/spark-related-packages/mr1-2.0.0-mr1-cdh4.2.0.tar.gz
        tar -xvzf mr1-*.tar.gz > /tmp/spark-ec2_mapreduce.log
        rm mr1-*.tar.gz
        mv hadoop-2.0.0-mr1-cdh4.2.0/ mapreduce/
        ;;

      *)
         echo "ERROR: Unknown Hadoop version"
         return -1
    esac
fi

/root/spark-ec2/copy-dir /root/mapreduce
popd

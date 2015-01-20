#!/bin/bash

pushd /root

if [ -d "ephemeral-hdfs" ]; then
  echo "Ephemeral HDFS seems to be installed. Exiting."
  return 0
fi

if [ -d "hadoop" ]; then
  echo "Hadoop build exists on image, using it. Details:"
  hadoop/bin/hadoop version

  cp -r hadoop ephemeral-hdfs

  # Have single conf dir
  rm -rf /root/ephemeral-hdfs/etc/hadoop/
  ln -s /root/ephemeral-hdfs/conf /root/ephemeral-hdfs/etc/hadoop

else

    case "$HADOOP_MAJOR_VERSION" in
      1)
        wget http://s3.amazonaws.com/spark-related-packages/hadoop-1.0.4.tar.gz
        echo "Unpacking Hadoop"
        tar xvzf hadoop-1.0.4.tar.gz > /tmp/spark-ec2_hadoop.log
        rm hadoop-*.tar.gz
        mv hadoop-1.0.4/ ephemeral-hdfs/
        sed -i 's/-jvm server/-server/g' /root/ephemeral-hdfs/bin/hadoop
        ;;
      2)
        wget http://s3.amazonaws.com/spark-related-packages/hadoop-2.0.0-cdh4.2.0.tar.gz
        echo "Unpacking Hadoop"
        tar xvzf hadoop-*.tar.gz > /tmp/spark-ec2_hadoop.log
        rm hadoop-*.tar.gz
        mv hadoop-2.0.0-cdh4.2.0/ ephemeral-hdfs/

        # Have single conf dir
        rm -rf /root/ephemeral-hdfs/etc/hadoop/
        ln -s /root/ephemeral-hdfs/conf /root/ephemeral-hdfs/etc/hadoop
        ;;

      *)
         echo "ERROR: Unknown Hadoop version"
         return -1
    esac

    # Assume this is version compatible!!!
    cp /root/hadoop-native/* ephemeral-hdfs/lib/native/

fi

# Don't copy-dir if we're running this as part of image creation.
if [ -d "/root/spark-ec2" ]; then
    /root/spark-ec2/copy-dir /root/ephemeral-hdfs
fi

popd


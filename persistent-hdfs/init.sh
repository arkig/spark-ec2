#!/bin/bash

pushd /root

if [ -d "persistent-hdfs" ]; then
  echo "Persistent HDFS seems to be installed. Exiting."
  return 0
fi

if [ -d "hadoop" ]; then
  echo "Hadoop build exists on image, using it"

  cp -r hadoop persistent-hdfs

  # Have single conf dir
  rm -rf /root/persistent-hdfs/etc/hadoop/
  ln -s /root/persistent-hdfs/conf /root/persistent-hdfs/etc/hadoop

else

  source ../hadoop/init.sh

  cp -r hadoop persistent-hdfs

  case `python -c "print '$HADOOP_VERSION'[0]"` in
    1)
      ;;
    2)
      # Have single conf dir
      rm -rf /root/persistent-hdfs/etc/hadoop/
      ln -s /root/persistent-hdfs/conf /root/persistent-hdfs/etc/hadoop
      ;;
    *)
      echo "ERROR: Unknown Hadoop version"
      return -1
  esac

  # Assume this is version compatible!!!
  cp /root/hadoop-native/* /root/persistent-hdfs/lib/native/

fi

# Don't copy-dir if we're running this as part of image creation.
if [ -d "/root/spark-ec2" ]; then
    /root/spark-ec2/copy-dir /root/persistent-hdfs
fi

popd

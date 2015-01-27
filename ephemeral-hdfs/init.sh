#!/bin/sh

pushd /root

if [ -d "ephemeral-hdfs" ]; then
  echo "Ephemeral HDFS seems to be installed. Exiting."
  return 0
fi

if [ -d "hadoop" ]; then
  echo "Hadoop build exists on image, using it."

  cp -r hadoop ephemeral-hdfs

  # Have single conf dir
  rm -rf /root/ephemeral-hdfs/etc/hadoop/
  ln -s /root/ephemeral-hdfs/conf /root/ephemeral-hdfs/etc/hadoop

else

  source ../hadoop/init.sh

  cp -r hadoop ephemeral-hdfs

  case `python -c "print '$HADOOP_VERSION'[0]"` in
    1)
      ;;
    2)
      # Have single conf dir
      rm -rf /root/ephemeral-hdfs/etc/hadoop/
      ln -s /root/ephemeral-hdfs/conf /root/ephemeral-hdfs/etc/hadoop
      ;;
    *)
      echo "ERROR: Unknown Hadoop version"
      return -1
  esac

fi

# Don't copy-dir if we're running this as part of image creation.
if [ -d "/root/spark-ec2" ]; then
    /root/spark-ec2/copy-dir /root/ephemeral-hdfs
fi

popd


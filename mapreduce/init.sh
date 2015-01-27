#!/bin/sh

pushd /root

if [ -d "mapreduce" ]; then
  echo "Map reduce seems to be installed. Exiting."
  return 0
fi

if [ -d "hadoop" ]; then
  echo "Hadoop build exists on image, using it."

  cp -r hadoop mapreduce

  # Have single conf dir
  rm -rf /root/mapreduce/etc/hadoop/
  ln -s /root/mapreduce/conf /root/mapreduce/etc/hadoop

else

  source ../hadoop/init.sh

  cp -r hadoop mapreduce

  case `python -c "print '$HADOOP_VERSION'[0]"` in
    1)
      ;;
    2)
      # Have single conf dir
      rm -rf /root/mapreduce/etc/hadoop/
      ln -s /root/mapreduce/conf /root/mapreduce/etc/hadoop
      ;;
    *)
      echo "ERROR: Unknown Hadoop version"
      return -1
  esac

fi

# Don't copy-dir if we're running this as part of image creation.
if [ -d "/root/spark-ec2" ]; then
    /root/spark-ec2/copy-dir /root/mapreduce
fi

popd

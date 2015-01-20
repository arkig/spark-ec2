#!/bin/bash

pushd /root

if [ -d "spark" ]; then
  echo "Spark seems to be installed. Exiting."
  return
fi

# TODO
echo "** Warning: ignoring SPARK_VERSION=$SPARK_VERSION **"
SPARK_VERSION="https://github.com/apache/spark|tags/v1.2.0"

# Github tag:
if [[ "$SPARK_VERSION" == *\|* ]]
then

  HADOOP_VERSION="2.4.1"
  # TODO find way of specifying Tachyon version in build via command line... probably not possible until they make it a property.

  # Note: this takes a over an hour on an m3.medium
  # TODO find way of selecting which modules to build, as we don't need all of them.
  echo "Building Spark from $repo, hash: $git_hash against Hadoop $HADOOP_VERSION"
  mkdir spark
  pushd spark
  git init
  repo=`python -c "print '$SPARK_VERSION'.split('|')[0]"`
  git_hash=`python -c "print '$SPARK_VERSION'.split('|')[1]"`
  git remote add origin $repo
  git fetch origin
  git checkout $git_hash
  export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=512M -XX:ReservedCodeCacheSize=512m"
  # TODO need -Phadoop-provided ??
  # TODO mvn install ??
  mvn -Pyarn -Phadoop-2.4 -Dhadoop.version=${HADOOP_VERSION} -DskipTests clean package
  popd


# Pre-packaged spark version:
else 
  case "$SPARK_VERSION" in
    1.2.0)
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget http://s3.amazonaws.com/spark-related-packages/spark-1.2.0-bin-hadoop1.tgz
      else
        wget http://s3.amazonaws.com/spark-related-packages/spark-1.2.0-bin-hadoop2.4.tgz
        #wget http://s3.amazonaws.com/spark-related-packages/spark-1.2.0-bin-cdh4.tgz
      fi
      ;;
    *)
      echo "ERROR: Unknown Spark version"
      return
  esac

  echo "Unpacking Spark"
  tar xvzf spark-*.tgz > /tmp/spark-ec2_spark.log
  rm spark-*.tgz
  mv `ls -d spark-* | grep -v ec2` spark
fi

popd

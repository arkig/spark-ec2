#!/bin/bash

pushd /root

if [ -d "tachyon" ]; then
  echo "Tachyon seems to be installed. Exiting."
  return 0
fi

#TACHYON_VERSION=0.4.1

# Version currently built against in spark 1.2 .. see core/pom.xml
TACHYON_VERSION="git://github.com/amplab/tachyon.git|tags/v0.5.0"

# Github tag:
if [[ "$TACHYON_VERSION" == *\|* ]]
then

  HADOOP_VERSION="2.4.1"

  # See http://tachyon-project.org/master/Building-Tachyon-Master-Branch.html
  echo "Building Tachyon ${TACHYON_VERSION} against Hadoop ${HADOOP_VERSION}..."

  #git clone git://github.com/amplab/tachyon.git
  #cd tachyon
  #git checkout tags/v$TACHYON_VERSION

  mkdir tachyon
  pushd tachyon
  git init
  repo=`python -c "print '$TACHYON_VERSION'.split('|')[0]"`
  git_hash=`python -c "print '$TACHYON_VERSION'.split('|')[1]"`
  git remote add origin $repo
  git fetch origin
  git checkout $git_hash

  mvn -Dhadoop.version=${HADOOP_VERSION} -DskipTests clean install
  bin/tachyon version
  echo "Done"

# Pre-package tachyon version
else
  case "$TACHYON_VERSION" in
    0.3.0)
      wget https://s3.amazonaws.com/Tachyon/tachyon-0.3.0-bin.tar.gz
      ;;
    0.4.0)
      wget https://s3.amazonaws.com/Tachyon/tachyon-0.4.0-bin.tar.gz
      ;;
    0.4.1)
      wget https://s3.amazonaws.com/Tachyon/tachyon-0.4.1-bin.tar.gz
      ;;
    0.5.0)
      wget https://s3.amazonaws.com/Tachyon/tachyon-0.5.0-bin.tar.gz
      ;;
    *)
      echo "ERROR: Unknown Tachyon version"
      return -1
  esac

  echo "Unpacking Tachyon"
  tar xvzf tachyon-*.tar.gz > /tmp/spark-ec2_tachyon.log
  rm tachyon-*.tar.gz
  mv `ls -d tachyon-*` tachyon
fi

# Don't copy-dir if we're running this as part of image creation.
if [ -d "/root/spark-ec2" ]; then
  /root/spark-ec2/copy-dir /root/tachyon
fi

popd

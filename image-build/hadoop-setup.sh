#!/bin/sh

# Useful:
# - https://cyberfrontierlabs.com/2014/09/30/installing-hadoop-2-5-1-on-centos-7/

set -e
set -x
set -u

# Install Maven (for building Hadoop, etc)
cd /tmp
wget "http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz"
tar xvzf apache-maven-${MAVEN_VERSION}-bin.tar.gz
sudo mv apache-maven-${MAVEN_VERSION} /opt/
# Edit bash profile
echo "export M2_HOME=/opt/apache-maven-${MAVEN_VERSION}" >> ~/.bash_profile
echo "export PATH=\$PATH:\$M2_HOME/bin" >> ~/.bash_profile
set +u
source ~/.bash_profile
set -u

# Prerequisites
sudo yum install -y protobuf-compiler cmake openssl-devel

# Install exact required version of protobuf
cd /tmp
wget https://protobuf.googlecode.com/svn/rc/protobuf-${PROTOBUF_VERSION}.tar.gz
tar xf protobuf-${PROTOBUF_VERSION}.tar.gz
cd protobuf-${PROTOBUF_VERSION}
./configure
make
make check
sudo make install

# Install FUSE
sudo yum -y install fuse fuse-devel fuse-libs

# Install Snappy lib (for Hadoop)
sudo yum install -y snappy

# Build Hadoop
cd /tmp
wget "http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}-src.tar.gz"
tar xvzf hadoop-${HADOOP_VERSION}-src.tar.gz
cd hadoop-${HADOOP_VERSION}-src
# Take care of possibility that we have multiple versions.
export HADOOP_PROTOC_PATH="/usr/local/bin/protoc"
#mvn package -Pdist,native -DskipTests -Dtar
mvn package -Pdist,native -Drequire.fuse=true -Dsnappy.lib=/usr/lib64/,require.snappy -DskipTests -Dtar

# Keep build so we can use it later
rm -rf /root/hadoop
mv hadoop-dist/target/hadoop-${HADOOP_VERSION} /root/hadoop

# Grab fuse_dfs
rm -rf /root/hadoop_extra
mkdir -p /root/hadoop_extra/bin
cp hadoop-hdfs-project/hadoop-hdfs/target/native/main/native/fuse-dfs/*fuse_dfs* /root/hadoop_extra/bin/

# TODO check if still need this
sudo ln -sf /usr/lib64/libsnappy.so.1 /root/hadoop/lib/native/.

# Grab native libs only for later use in modules (in case we download a different hadoop)
mkdir /root/hadoop-native
cp /root/hadoop/lib/native/* /root/hadoop-native

# hadoop user ownership/setup??


# Clean up
rm -rf /tmp/*

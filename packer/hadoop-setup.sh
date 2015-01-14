#!/bin/sh

# Useful:
# - https://cyberfrontierlabs.com/2014/09/30/installing-hadoop-2-5-1-on-centos-7/

# Install Maven (for Hadoop)
cd /tmp
MAVEN_VERSION="3.2.3"
wget "http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz"
tar xvzf apache-maven-${MAVEN_VERSION}-bin.tar.gz
mv apache-maven-${MAVEN_VERSION} /opt/
# Edit bash profile
echo "export M2_HOME=/opt/apache-maven-${MAVEN_VERSION}" >> ~/.bash_profile
echo "export PATH=\$PATH:\$M2_HOME/bin" >> ~/.bash_profile
source ~/.bash_profile

# Install exact required version of protobuf
PROTOBUF_VERSION="2.5.0"
cd /tmp
wget https://protobuf.googlecode.com/svn/rc/protobuf-${PROTOBUF_VERSION}.tar.gz
tar xf protobuf-${PROTOBUF_VERSION}.tar.gz
cd protobuf-${PROTOBUF_VERSION}
./configure
make
make check
sudo make install

# Build Hadoop to install native libs
HADOOP_VERSION="2.4.1"
sudo yum install -y protobuf-compiler cmake openssl-devel
sudo mkdir /root/hadoop-native
cd /tmp
wget "http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}-src.tar.gz"
tar xvzf hadoop-${HADOOP_VERSION}-src.tar.gz
cd hadoop-${HADOOP_VERSION}-src
mvn package -Pdist,native -DskipTests -Dtar
sudo mv hadoop-dist/target/hadoop-${HADOOP_VERSION}/lib/native/* /root/hadoop-native

# Keep build in case we want to use it later
sudo rm -rf /root/hadoop
sudo mv hadoop-dist/target/hadoop-${HADOOP_VERSION} /root/hadoop

# hadoop user ownership/setup??

# Install Snappy lib (for Hadoop)
sudo yum install -y snappy
sudo ln -sf /usr/lib64/libsnappy.so.1 /root/hadoop-native/.

# Clean up
rm -rf /tmp/*

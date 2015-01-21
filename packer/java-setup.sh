#!/bin/sh

source ./image_variables.sh

# Should be done by now
# sudo yum install -y gcc gcc-c++

# cant find packages
#sudo yum-complete-transaction
#sudo debuginfo-install -q -y glibc

sudo yum install -y java-${JAVA_VERSION}-openjdk-devel ant

#sudo yum --enablerepo='*-debug*' install -q -y java-${JAVA_VERSION}-openjdk-debuginfo.x86_64

# Really need this??
echo "export JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}" >> ~/.bash_profile

source ~/.bash_profile


# TODO use oracle jdk instead.. find what version best.
#wget http://download.oracle.com/otn-pub/java/jdk/8u11-b12/jdk-8u11-linux-x64.tar.gz
#tar -zxvz jdk-8u11-linux-64.tar.gz /opt/jdk1.9.0_11
#/usr/sbin/alternatives --install /opt/jdk1.8.0_11/bin/java
#alternatives --config
#java -version
#export JAVA_HOME=/opt/jdk1.8.0_11/
#export PATH=$JAVA_HOME/bin:$PATH
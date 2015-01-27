#!/bin/sh

set -e
set -x
set -u

if [ -n "$(command -v java)" ]; then
    echo "Java appears to be installed. Cannot continue!"
    return -1
fi

if [ -n "$ORACLE_JAVA_VERSION" ]; then

    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${ORACLE_JAVA_VERSION}-b13/jdk-${ORACLE_JAVA_VERSION}-linux-x64.rpm
    sudo rpm -ivh jdk-${ORACLE_JAVA_VERSION}-linux-x64.rpm
    rm -f jdk-${ORACLE_JAVA_VERSION}-linux-x64.rpm

    #wget http://download.oracle.com/otn-pub/java/jdk/8u11-b12/jdk-8u11-linux-x64.tar.gz
    #tar -zxvz jdk-8u11-linux-64.tar.gz /opt/jdk1.9.0_11
    #/usr/sbin/alternatives --install /opt/jdk1.8.0_11/bin/java
    #alternatives --config
    #java -version
    #export JAVA_HOME=/opt/jdk1.8.0_11/
    #export PATH=$JAVA_HOME/bin:$PATH

elif [ -n "$OPENJDK_JAVA_VERSION" ]; then

    sudo yum install -y java-${OPENJDK_JAVA_VERSION}-openjdk-devel
    #sudo yum --enablerepo='*-debug*' install -q -y java-${OPENJDK_JAVA_VERSION}-openjdk-debuginfo.x86_64

    # Pointless, as other scripts don't run in this environment
    # echo "export JAVA_HOME=/usr/lib/jvm/java-${OPENJDK_JAVA_VERSION}" >> ~/.bash_profile

else
    echo "No Java version specified. Exiting"
    return -1
fi



#!/bin/sh

set -e
set -x
set -u

if [ -n "$(command -v java)" ]; then
    echo "Java appears to be installed. Cannot continue."
    return -1
fi

if [ -n "$ORACLE_JAVA_VERSION" ]; then

    ################################################################################################
    # *WARNING* The code below is commented out because it accepts Oracle's JDK license agreement, #
    #           which is a condition of downloading the software.                                  #
    #           This functionality should not be available by default.                             #
    ################################################################################################

    FAIL_JAVA_INSTALL=true

    #### wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${ORACLE_JAVA_VERSION}-b13/jdk-${ORACLE_JAVA_VERSION}-linux-x64.rpm
    #### sudo rpm -ivh jdk-${ORACLE_JAVA_VERSION}-linux-x64.rpm
    #### rm -f jdk-${ORACLE_JAVA_VERSION}-linux-x64.rpm

    #### # Note: We know ORACLE_JAVA_VERSION will be latest

    #### sudo alternatives --install /usr/bin/java java /usr/java/latest/jre/bin/java 200000
    #### sudo alternatives --install /usr/bin/javaws javaws /usr/java/latest/jre/bin/javaws 200000
    #### sudo alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000
    #### sudo alternatives --install /usr/bin/jar jar /usr/java/latest/bin/jar 200000

    #### echo "export JAVA_HOME=/usr/java/latest" >> ~/.bash_profile
    #### FAIL_JAVA_INSTALL=false


    if FAIL_JAVA_INSTALL; then
        echo "Cannot install Oracle JDK. Please refer to java-setup.sh. Exiting"
        return 1
    fi

elif [ -n "$OPENJDK_JAVA_VERSION" ]; then

    sudo yum install -y java-${OPENJDK_JAVA_VERSION}-openjdk-devel
    #sudo yum --enablerepo='*-debug*' install -q -y java-${OPENJDK_JAVA_VERSION}-openjdk-debuginfo.x86_64

    echo "export JAVA_HOME=/usr/lib/jvm/java-${OPENJDK_JAVA_VERSION}" >> ~/.bash_profile

else
    echo "No Java version specified. Exiting"
    return 1
fi



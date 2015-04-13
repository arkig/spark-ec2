#!/bin/sh
#
# Wrapper for fuse_dfs

HADOOP_HOME=${HADOOP_HOME-"/root/hadoop"}
HADOOP_EXTRA=${HADOOP_EXTRA-"/root/hadoop_extra"}

# In particular for JAVA_HOME
source ~/.bash_profile

if [ "$HADOOP_PREFIX" != "" ]; then
    # Note that setting HADOOP_PREFIX means the results of hadoop classpath become relative to that.
    # This breaks the CLASSPATH variable below.
    echo "Can't have HADOOP_PREFIX set!"
    exit 1
fi

if [ "$OS_ARCH" = "" ]; then
    OS_ARCH="amd64"
fi

if [ "$JAVA_HOME" = "" ]; then
    echo "Must set JAVA_HOME"
    exit 1
fi

if [ "$LD_LIBRARY_PATH" = "" ]; then
    # removed /usr/local/lib:
    export LD_LIBRARY_PATH=$JAVA_HOME/jre/lib/$OS_ARCH/server:$HADOOP_HOME/lib/native
fi

export CLASSPATH=$($HADOOP_HOME/bin/hadoop classpath | sed s/:/'\n'/g | awk '/\*$/ {print "ls", $0 ".jar"}' | sh | sed ':a;N;$!ba;s/\n/:/g')

#echo "LD_LIBRAYY_PATH=$LD_LIBRARY_PATH"
#echo "CLASSPATH=$CLASSPATH"

$HADOOP_EXTRA/bin/fuse_dfs $@


#!/bin/sh

# One location for configuring these for:
# - manual image creation / testing
# - use in packer (via a hack)

echo "Setting image variables"

export PARALLEL_VERSION=${PARALLEL_VERSION-"20141122"}

# NOTE: Use this only iff you fully understand the consequences.
#       See java-setup.sh
#### export ORACLE_JAVA_VERSION=${ORACLE_JAVA_VERSION-"7u75"}

# Note: OpenJDK is used iff ORACLE_JAVA_VERSION is not set.
export OPENJDK_JAVA_VERSION=${OPENJDK_JAVA_VERSION-"1.7.0"}

export MAVEN_VERSION=${MAVEN_VERSION-"3.2.3"}
export PROTOBUF_VERSION=${PROTOBUF_VERSION-"2.5.0"}
#export HADOOP_VERSION=${HADOOP_VERSION-"2.4.1"}
export HADOOP_VERSION=${HADOOP_VERSION-"2.6.0"} #TODO Testing

export PYTHON_VERSION=${PYTHON_VERSION-"2.7.9"}

# Note: 7.8 won't compile
export VW_VERSION=${VW_VERSION-"7.7"}


# For (optional) module initialisation on image
# ---------------------------------------------

# Note: ganglia left out as unsure whether it relies on mount setups
#export IMAGE_MODULES=${IMAGE_MODULES-"ephemeral-hdfs persistent-hdfs mapreduce scala tachyon spark"}
export IMAGE_MODULES=${IMAGE_MODULES-"ephemeral-hdfs scala tachyon spark"}

export SCALA_VERSION=${SCALA_VERSION-"2.10.3"}

# Version currently built against in spark 1.2 .. see core/pom.xml
export TACHYON_VERSION=${TACHYON_VERSION-"git://github.com/amplab/tachyon.git|tags/v0.5.0"}

export SPARK_VERSION=${SPARK_VERSION-"https://github.com/apache/spark|tags/v1.2.0"}


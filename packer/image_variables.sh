#!/bin/sh

export PARALLEL_VERSION="20141122"

export JAVA_VERSION="1.7.0"

export MAVEN_VERSION="3.2.3"
export PROTOBUF_VERSION="2.5.0"
export HADOOP_VERSION="2.4.1"

export PYTHON_VERSION="2.7.9"

# 7.8 won't compile
export VW_VERSION="7.7"

# For (optional) module initialisation on image
# ---------------------------------------------

# Note: ganglia left out as unsure whether it relies on mount setups
export IMAGE_MODULES="scala spark ephemeral-hdfs persistent-hdfs mapreduce spark-standalone tachyon"

export SCALA_VERSION="2.10.3"

# Version currently built against in spark 1.2 .. see core/pom.xml
export TACHYON_VERSION="git://github.com/amplab/tachyon.git|tags/v0.5.0"

export SPARK_VERSION="https://github.com/apache/spark|tags/v1.2.0"


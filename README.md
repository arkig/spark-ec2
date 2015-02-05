# spark-ec2 for Data Science

This repository contains a set of scripts used to setup a functional data science cluster on EC2 using the Spark stack and common data science tools.

There are two components to this:
* Automatically build and register an AMI that is pre-configured as much as possible, starting with a CentOS 6 minimal image.
* Deploy and configure a cluster using this AMI

This work is based on https://github.com/mesos/spark-ec2 and forks. Please see the README.md there for additional details. 

These scripts are currently compatible with https://github.com/apache/spark/blob/master/ec2/spark_ec2.py, **however you will need to modify it so that it pulls this repo and branch instead of the mesos repo**.

## Components

Modules:

* Spark in standalone mode (yarn not yet enabled)
* Tachyon
* Hadoop DFS running on the instances' local disks.
* Ganglia
* Any RPMs (for additional software)

The above modules are configured to work together by these scripts. By default, they are pre-installed on the image in order to optimise cluster start time.
The default versions are: Spark 1.2, Tachyon 0.5, Protobuf 2.5.0 and Hadoop 2.4.1. These are compiled from source against each other to ensure compatibility. 
You may change these versions or use pre-built distributions, but be aware of the dependencies between them and with the configuration files in `./templates`.

Data science software on the image:

* Python 2.7 and SciPy libraries
* R (TODO add libraries)
* Vowpal Wabbit


## Usage

Build the image according to `./packer/README.MD`
 
Pass the new image id to the modified (see above) `spark_ec2.py` using the `--ami` argument.   

## Details

This assumes you are familiar with how [spark-ec2](https://github.com/mesos/spark-ec2) works.

* The modules' optional `init.sh` scripts can be run as part of the image build. They are always run at cluster deploy time. They will the situation and act appropriately. This is the mechanism that allows you to decide what you want on the AMI vs what is installed at deployment time. 
* The modules' optional `setup.sh` scripts generally start services and do anything that cannot be done at image build time.  
* The modules' optional `test.sh` scripts are run after all the setup is complete. They allow you to perform simple tests/checks. 

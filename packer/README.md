# Spark Data Science Packer Scripts

These scripts were derived from [work done here](from https://github.com/nchammas/spark-ec2/tree/packer)

These scripts use [Packer](http://www.packer.io/) to create and register an AMI that includes all the software needed to quickly launch a Spark based data science cluster on EC2.

The base operating system is the latest Centos 6 minimal AMI, rather than Amazon Linux.
 
The image includes common data science tools, including
 * R (TODO add common data science libraries)
 * Python 2.7 and all SciPy libraries
 * Vowpal Wabbit

To speed up cluster launches, most of the epark-ec2 modules are also installed on the image by default.  

## Usage

See / modify the following file to control software versions, as well as which modules will be installed on the image:

``` 
image-variables.sh
```

Then just call this script:

```
./build_spark_amis.sh
```

Note that you can call this script from any working directory and it will work.

You can then use the resulting image by passing it to the ec2/spark_ec2.py script (in the spark github repo) using the --ami argument. Please note that the image is likely not compatible with the 
configuration in the original spark-ec2 scripts. You should therefore use those in this repo. This may require modification of spark_ec2.py to point to this repo.   

## Generated AMIs

Generated images are EBS-backed.
Currently, only Hardware Virtual Machine (HVM) virtualisation is implemented. This covers the majority of recent instance types. Paravirtual (PV) is easily added. 

# Prerequisites

[Download](http://www.packer.io/downloads.html) and install Packer to use the scripts here.

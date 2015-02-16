# Spark Data Science Image Creation Scripts

These scripts were derived from [work done here](https://github.com/nchammas/spark-ec2/tree/packer)

These scripts use [Packer](http://www.packer.io/) to create and register an AMI that includes all the software needed to quickly launch a Spark based data science cluster on EC2.

The base operating system is the latest Centos 6 minimal AMI, rather than Amazon Linux. 
It has been configured to work on EC2 and includes a good selection of dev tools for C++, Java and Scala.
 
The image includes common data science tools such as R, Python, SciPy, vowpal wabbit. Most are built from source. 

To speed up cluster launches, most of the `epark-ec2` modules are also installed on the image by default. 

## Usage

See/modify the following file to control software versions, as well as which modules will be installed on the image:

``` 
image-variables.sh
```

Then just call this script:

```
./build_spark_amis.sh
```

Note that you can call this script from any working directory and it will work.

You should expect it to take a couple of hours to complete. 

Please note that the resulting image is likely not compatible with the configuration in the original `spark-ec2` scripts.

## Generated AMIs

Generated images are EBS-backed.

Currently, only Hardware Virtual Machine (HVM) virtualisation is implemented. This covers the majority of recent instance types. Paravirtual (PV) is easily added. 

# Prerequisites

[Download](http://www.packer.io/downloads.html) and install Packer to use the scripts here.

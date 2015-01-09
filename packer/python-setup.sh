#!/bin/bash
# Setup python

# See http://toomuchdata.com/2014/02/16/how-to-install-python-on-centos/
# See comments in http://bicofino.io/blog/2014/01/16/installing-python-2-dot-7-6-on-centos-6-dot-5/
# Also relevant, but can't se this working: http://digiactive.com.au/blog/2013/12/28/setting-up-python-2-dot-7-on-centos-6-dot-4-the-really-easy-way/

sudo yum groupinstall -y "Development tools"
sudo yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel

# For scipy optimisations
sudo yum install -y gcc gcc-gfortran gcc-c++ blas-devel lapack-devel atlas-devel

# Already installed by now
#sudo yum install -y libgfortran

# For matplotlib
sudo yum install -y libpng-devel
# Following not available.
#sudo yum install -y libpng12-dev
#sudo yum install -y libfreetype6-dev.
# TODO these (ok without as matplot lib uses local copy)
#libagg
#pycxx
#qhull


# Install Python from source
PYTHON_VERSION="2.7.9"
cd /tmp
wget http://python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz
tar xf Python-${PYTHON_VERSION}.tar.xz
cd Python-${PYTHON_VERSION}
./configure --prefix=/usr/local --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
make && make altinstall

# Install setuptools...
cd /tmp
wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
#... for python 2.7
python2.7 ez_setup.py

# Install pip using the newly installed setuptools:
easy_install-2.7 pip

# Packages
# See: http://www.scipy.org/stackspec.html#stackspec
pip2.7 install numpy
pip2.7 install psutil
pip2.7 install tornado
pip2.7 install pyzmq
# Unsure if all optimisations worked for this...
pip2.7 install scipy
pip2.7 install ipython
pip2.7 install pandas

pip2.7 install pyparsing
pip2.7 install matplotlib
# To check backends:
# > import matplotlib.rcsetup as rcsetup
# > print(rcsetup.all_backends)
# TODO want to install latex first

#pip2.7 install Theano


rm -rf /tmp/*


# ---- OLD -----

# go get python27 etc..
#sudo yum install -y centos-release-SCL

# Python 2.7
#sudo yum install -y python27 python27-devel

#urgh...
#scl enable python27 bash

# pipe below into above?
#sudo curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py | sudo python27

#sudo easy_install-2.7 pip
#sudo pip2.7 install numpy
#sudo pip2.7 install psutil
#sudo pip2.7 install tornado
#sudo pip2.7 install scipy
#sudo pip2.7 install matplotlib



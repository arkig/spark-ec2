#!/bin/sh
# Setup python

# See http://toomuchdata.com/2014/02/16/how-to-install-python-on-centos/
# See comments in http://bicofino.io/blog/2014/01/16/installing-python-2-dot-7-6-on-centos-6-dot-5/
# Also relevant, but can't se this working: http://digiactive.com.au/blog/2013/12/28/setting-up-python-2-dot-7-on-centos-6-dot-4-the-really-easy-way/

# Assumed that various dev tools are already installed

set -e
set -x
set -u

# TODO check ${PYTHON_VERSION} is 2.7.x

# For scipy optimisations
sudo yum install -y gcc-gfortran blas-devel lapack-devel atlas-devel

# Probably already installed by now
sudo yum install -y libgfortran

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
cd /tmp
wget http://python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz
tar xf Python-${PYTHON_VERSION}.tar.xz
cd Python-${PYTHON_VERSION}
./configure --prefix=/usr/local --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
make
sudo make altinstall

# I need to do this for correct PATH
# ... and use sudo env "PATH=$PATH" so that it's available in sudo
set +u
source ~/.bash_profile
set -u

# Install setuptools...
cd /tmp
wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
sudo env "PATH=$PATH" python2.7 ez_setup.py

# Install pip using the newly installed setuptools:
sudo env "PATH=$PATH" easy_install-2.7 pip

# Packages
# See: http://www.scipy.org/stackspec.html#stackspec
sudo env "PATH=$PATH" pip2.7 install numpy
sudo env "PATH=$PATH" pip2.7 install psutil
sudo env "PATH=$PATH" pip2.7 install tornado
sudo env "PATH=$PATH" pip2.7 install pyzmq
# Unsure if all optimisations worked for this...
sudo env "PATH=$PATH" pip2.7 install scipy
sudo env "PATH=$PATH" pip2.7 install ipython
sudo env "PATH=$PATH" pip2.7 install pandas

sudo env "PATH=$PATH" pip2.7 install pyparsing
sudo env "PATH=$PATH" pip2.7 install matplotlib
# To check backends:
# > import matplotlib.rcsetup as rcsetup
# > print(rcsetup.all_backends)
# TODO want to install latex first

#sudo env "PATH=$PATH" pip2.7 install Theano

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



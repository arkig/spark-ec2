#!/bin/sh

source ./image_variables.sh

# Boost dependency
sudo yum install -y boost boost-devel

# consider adding this:
#sudo yum install -y clang

cd /tmp
git clone https://github.com/JohnLangford/vowpal_wabbit.git
cd vowpal_wabbit
git checkout tags/${VW_VERSION}
./autogen.sh
make
# TODO  Need later version of Perl
# make test
sudo make install

rm -rf /tmp/*


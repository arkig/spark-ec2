#!/bin/sh

# Boost dependency
sudo yum install -y boost boost-devel

# consider adding this:
#sudo yum install -y clang

# 7.8 won't compile

VW_VERSION="7.7"
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


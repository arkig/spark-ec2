#!/bin/sh
# Reclaim space

set -e
set -x
set -u

# Purge mvn repo
rm -rf /root/.m2/repository

# Clean up
rm -rf /tmp/*


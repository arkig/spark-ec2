#!/bin/sh

# Not ganglia specific...

echo "SElinux..."
sestatus

echo "Listening tcp ports..."
netstat -anp | grep -i list | grep tcp

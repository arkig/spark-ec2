#!/bin/sh
#
# Allow complete flexibility by delegation.
# E.g. use spark_ec2.py to copy things to /root/extra/

if [[ -e /root/extra/init.sh ]]; then
  echo "Delegating to extra/init.sh..."
  source /root/extra/init.sh
else
  echo "No extra/init.sh to delegate to"
fi

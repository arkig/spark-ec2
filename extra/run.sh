#!/bin/sh

# For example, use this to launch spark applications.

if [[ -e /root/extra/run.sh ]]; then
  echo "Delegating to extra/run.sh..."
  source /root/extra/run.sh
else
  echo "No extra/run.sh to delegate to"
fi

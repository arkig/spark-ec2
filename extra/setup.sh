#!/bin/sh

if [[ -e /root/extra/setup.sh ]]; then
  echo "Delegating to extra/setup.sh..."
  /root/extra/setup.sh
else
  echo "No extra/setup.sh to delegate to"
fi

#!/bin/sh

if [[ -e /root/extra/test.sh ]]; then
  echo "Delegating to extra/test.sh..."
  /root/extra/test.sh
else
  echo "No extra/test.sh to delegate to"
fi

#!/bin/bash

content=$(wl-paste 2>/dev/null)

if [ -z "$content" ]; then
  echo "Clipboard empty"
else
  echo "${content:0:200}"
fi

#!/usr/bin/env bash

# This is mostly used as a template to be copy-pasted into some files

# get the current file location
if [ "${0::1}" = "/" ]; then
    shFileDir=$0
else
    shFileDir="$(pwd)/$0"
fi
shFileDir=$(echo "$shFileDir" | sed 's/\/[^\/]*$//')
echo $shFileDir

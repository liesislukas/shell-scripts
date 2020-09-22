#!/usr/bin/env sh

# basedir is $1 to enable this to run from anywhere
if [ $# -ne 1 ]; then
  echo "Usage: $0 <destination_dir>" 1>&2
  exit 1
fi

# user enters directory to work with as 1st param. e.g. `cmd .` would set base dir to same dir as cmd is called from
export BASEDIR=$1

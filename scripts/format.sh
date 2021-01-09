#!/usr/bin/env bash

set -e

cwd=`pwd`
script_folder=`cd $(dirname $0) && pwd`
file=$1

if [ -z "$file" ]
then
  # all files
  swift-format --configuration $script_folder/../.swift-format -ir $script_folder/../*.swift $script_folder/../Sources $script_folder/../Tests
else
  swift-format --configuration $script_folder/../.swift-format -ir $file
fi

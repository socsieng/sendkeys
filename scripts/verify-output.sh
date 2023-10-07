#!/usr/bin/env bash

set -e

cwd=`pwd`
script_folder=`cd $(dirname $0) && pwd`
output_folder="$script_folder/../.output"
build_folder="$script_folder/../.build/debug"
examples_folder="$script_folder/../examples"

mkdir -p $output_folder

rm -f $output_folder/example.js
touch $output_folder/example.js
code $output_folder/example.js
sleep 1

$build_folder/sendkeys transform -f $examples_folder/node.js | $build_folder/sendkeys -d 0.05
$build_folder/sendkeys -c '<c:s:command><m:100,100,300,300:0.1><p:1>'

expected_output=`cat $examples_folder/node.js`
result=`cat $output_folder/example.js`

if [[ "$expected_output" != "$result" ]]; then
  echo "transform test failed."
  exit 1
fi

#!/usr/bin/env bash

set -e

cwd=`pwd`
script_folder=`cd $(dirname $0) && pwd`
version=`cat $script_folder/../version.txt`

echo "updating version to $version"

sed -E -i ".bak" "s/version: \"[0-9]+\.[0-9]+\.[0-9]+\" \/\* auto-updated \*\//version: \"$version\" \/\* auto-updated \*\//g" $script_folder/../Sources/SendKeysLib/SendKeysCli.swift

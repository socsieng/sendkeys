#!/usr/bin/env bash

set -e

cwd=`pwd`
script_folder=`cd $(dirname $0) && pwd`
version=${1:-`cat $script_folder/../version.txt`}
formula_template=$script_folder/../Formula/sendkeys_template.rb
formula=$script_folder/../Formula/sendkeys.rb
url="file://$cwd/sendkeys.tar.gz"
sed_url=`echo $url | sed 's/\\//\\\\\//g'`

version=`echo $version | sed -E 's/^v//g'`

tar zcvf sendkeys.tar.gz --exclude=".git" --exclude=".build" ./

cp $formula_template $formula

# update url
sed -E -i "" "s/url \"\"/url \"$sed_url\"/g" $formula

# update version number
sed -E -i "" "s/version \"[0-9]+\.[0-9]+\.[0-9]+\"/version \"$version\"/g" $formula

brew install --force --build-bottle $formula
brew bottle sendkeys --force-core-tap --root-url "https://github.com/socsieng/sendkeys/releases/download/v${version}"

bottle=`ls sendkeys--$version.*.tar.gz`
bottle_rename=`echo $bottle | sed 's/sendkeys--/sendkeys-/g'`

mv $bottle $bottle_rename

echo ::set-output name=file::$bottle_rename
echo ::set-output name=root_url::"https://github.com/socsieng/sendkeys/releases/download/v${version}"
echo ::set-output name=url::"https://github.com/socsieng/sendkeys/releases/download/v${version}/$bottle_rename"
echo ::set-output name=sha::"$(shasum -a 256 $bottle_rename | awk '{printf $1}')"

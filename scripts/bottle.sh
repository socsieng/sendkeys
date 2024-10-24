#!/usr/bin/env bash

set -e

cwd=`pwd`
script_folder=`cd $(dirname $0) && pwd`
version=$1
formula_template=$script_folder/../Formula/sendkeys_template.rb
formula=$script_folder/../Formula/sendkeys.rb
url="file://$cwd/sendkeys.tar.gz?date=`date +%s`"
sed_url=`echo $url | sed 's/\\//\\\\\//g'`

version=`echo $version | sed -E 's/^v//g'`

rm sendkeys*.tar.gz || true
tar zcvf sendkeys.tar.gz --exclude=".git" --exclude=".build" ./

cp $formula_template $formula

# update url
sed -E -i "" "s/url \"\"/url \"$sed_url\"/g" $formula

# update version number
sed -E -i "" "s/version \"[0-9]+\.[0-9]+\.[0-9]+\"/version \"$version\"/g" $formula

brew install --force --formula --build-bottle $formula

echo "Bottle built"

brew bottle sendkeys --force-core-tap --no-rebuild --root-url "https://github.com/socsieng/sendkeys/releases/download/v${version}"

bottle=`ls sendkeys--$version.*.tar.gz`

cp $bottle "sendkeys-$version.big_sur.bottle.tar.gz"
cp $bottle "sendkeys-$version.arm64_big_sur.bottle.tar.gz"

echo "files=sendkeys-$version.*.bottle.tar.gz" >> $GITHUB_OUTPUT
echo "root_url=https://github.com/socsieng/sendkeys/releases/download/v${version}" >> $GITHUB_OUTPUT
echo "sha=$(shasum -a 256 $bottle | awk '{printf $1}')" >> $GITHUB_OUTPUT

brew uninstall sendkeys

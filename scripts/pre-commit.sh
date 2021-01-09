#!/usr/bin/env bash
set -e

# get the repository root
repo_folder=`git rev-parse --show-toplevel`

# use repository root if there is a value, otherwise use the current folder
root_folder=${repo_folder:-`pwd`}

files=`git diff --cached --name-only --diff-filter=ACM`

for f in $files
do
  echo "Formatting $f"
  $root_folder/scripts/format.sh $f
  git add $f
done

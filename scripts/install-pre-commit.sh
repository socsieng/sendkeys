#!/usr/bin/env bash
set -e

script_folder=`cd $(dirname $0) && pwd`
repo_folder=`git rev-parse --show-toplevel`

cp -f $script_folder/pre-commit.sh $repo_folder/.git/hooks/pre-commit

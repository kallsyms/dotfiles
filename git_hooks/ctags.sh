#!/bin/sh
# From https://tbaggery.com/2011/08/08/effortless-ctags-with-git.html

set -e

PATH="/usr/local/bin:$PATH"
dir="$(git rev-parse --git-dir)"

trap 'rm -f "$dir/$$.tags"' EXIT

git ls-files | ctags --tag-relative=yes -L - -f "${dir}/$$.tags"

mv "$dir/$$.tags" "${dir}/tags"

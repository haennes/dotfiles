#!/usr/bin/env bash
set -xeuo pipefail
pushd "${0%/*}" || exit

# diffs
dff=$(mktemp)
git diff -a --submodule=diff > "$dff" || exit 1

revpatch() {
  local dest=$1 
  rsync -a --exclude='.git' --exclude='.gitmodules' . "$dest" || exit 1
  pushd "$dest" || exit 1
    patch -p1 < "$dff" --reverse
  popd || exit 1
}

rawdir=$(mktemp -d)
revpatch "$rawdir"

fmtdir=$(mktemp -d)
revpatch "$fmtdir"
pushd "$fmtdir" || exit 1
  ./fmt || exit 1
popd || exit 1

diff -r "$rawdir" "$fmtdir" || exit 1

popd || exit

#!/usr/bin/env bash

# This script copies the treesitter queries from the source directory containing the repo to the runtimepath for treesitter queries.

if [ ! $# -eq 0 ]; then
  targets="$1"
else
  targets="./*"
fi

for query in $targets ; do
    dir=~/.config/nvim/queries/${query##*-}
    mkdir -p "$dir"
    cp $file/queries/* "$dir/"
done

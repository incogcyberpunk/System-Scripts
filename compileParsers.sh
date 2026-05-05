#!/usr/bin/env bash

# This script compiles the parsers from the source directory containing the repo to the runtimepath for treesitter parsers.

base=$(pwd)

if [ ! $# -eq 0 ]; then
  targets="$1"
else
  targets="./*"
fi

for parser in $targets; do
  [ -d "$parser/src" ] || continue

  echo "$parser"
  parserName=${parser##*-}
  echo "$parserName"

  cd "$parser/src"

  srcs="parser.c"
  [ -f scanner.c ] && srcs="$srcs scanner.c"

  gcc -O2 -shared -fPIC -I. -o "$parserName.so" $srcs \
    && cp "$parserName.so" ~/.config/nvim/parser/

  cd "$base"
done

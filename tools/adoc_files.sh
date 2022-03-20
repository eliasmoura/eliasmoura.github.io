#!/bin/sh --

dir=$1

find src/blog -name \*.adoc -type f | while read -r f; do
  f=${f#src/blog/}
  printf "$dir/%shtml\\n" "${f%adoc}"
done

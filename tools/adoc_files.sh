#!/bin/sh --

dir=$1

for f in src/*.adoc; do f=${f#src/}; printf "$dir/%shtml\\n" "${f%adoc}"; done;

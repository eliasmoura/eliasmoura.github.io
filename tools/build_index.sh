#!/bin/sh --

# Create the index.adoc using `git log` + 'coreutils utilits' to list and order the adoc files by date.

printf "= Index\\nbuild_index.sh\\n:keywords: index, blog, noobkotto\\n:description: Blog's post index.\\n\\n"

for f in src/*.adoc; do git log --diff-filter=A --follow --format="%at $f" -- "$f" | tail -1; done | sort | while read -r date_ doc; do link=$doc; link=${link#src}; title="$(head -n 1 "$doc")"; printf "link:%s[%s] %s\\n" "${link%adoc}html" "${title#= }" "$(LANG=C date '+%Y-%m-%d' -d @"$date_")"; done

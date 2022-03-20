#!/bin/sh --

# Print the archive.adoc to stdout using `git log` + 'coreutils utilits' to list and order the adoc files by date.

printf '= Index\nbuild_archive.sh\n:keywords: archive, blog, eliasmoura\n:description: Elias Moura's Blog's post archive.\n\n'

find src/blog -name \*.adoc | while read -r f; do
  git log --diff-filter=A --follow --format="%at $f" -- "$f" | tail -1;
done | sort | while read -r date_ doc; do
  link=${doc#src/}
  title="$(head -n 1 "$doc")"
  printf "%s link:%s[%s]\\n\\n"  "$(LANG=C date '+%Y-%m-%d' -d @"$date_")" "${link%adoc}html" "${title#= }"
done

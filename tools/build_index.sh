#!/bin/sh --

# Print the archive.adoc to stdout using `git log` + 'coreutils utilits' to list and order the adoc files by date.

printf ":keywords: archive, blog, eliasmoura\\n:description: Elias Moura's blog.\\n\\n"

find src/ -name \*.adoc -type f | while read -r f; do
  git log --diff-filter=A --follow --format="%at $f" -- "$f" | tail -1;
done | sort --reverse | head -n 3 | while read -r date_ doc; do
  link="${doc#src/}"
  link="${link%adoc}html"
  title="$(head -n 1 "$doc")"
  title="${title#= }"
  printf "\\n== link:%s[%s]\\n%s\\n" "$link" "$title" "$(LANG=C date '+%Y-%m-%d' -d @"$date_")"
  awk 'f{print} /^:description:/{f=1}' "$doc"
done

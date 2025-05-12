#! /bin/bash

export PROJECT=foobar
REPOS+=https://github.com/aileron-project/aileron-project.git
PATTERNS+=("^v[0-9]+.[0-9]+.[0-9]+$")
PATTERNS+=("^v[0-9]+.[0-9]+.[0-9]+-alpha$")
OTHERS+=()
# FILES=$(find ./docs/ -maxdepth 2 -mindepth 2 -type f -name '*.adoc' 2>/dev/null)

# git clone https://github.com/aileron-project/aileron-project.git
# cd aileron-project
TAGS=$(git tag)

echo "${TAGS}" | while read -r line; do
  for pattern in "${PATTERNS[@]}"; do
    echo "${line}" "<>" "${pattern}"
    if [[ "${line}" =~ ${pattern} ]]; then
      echo "${line}" >>"${PROJECT}.list"
      break
    fi
  done
  for other in "${OTHERS[@]}"; do
    echo "${line}" "<>" "${other}"
    if [[ "${line}" =~ ${other} ]]; then
      echo "${line}" >>"${PROJECT}.list"
      break
    fi
  done
done

# gem install asciidoctor
# gem install coderay

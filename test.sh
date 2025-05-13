#! /bin/bash

# PROJECT="aileron-test"
git clone "https://github.com/aileron-project/${PROJECT}.git"
TAGS=$(cd "${PROJECT}" && git tag)
# PATTERNS=()

echo "--------------------"
echo "TAGS"
echo "${TAGS}"
echo "--------------------"

TARGETS=()

# echo "${TAGS}" | while read -r line; do
while read -r line; do
  echo "TAG: ${line}"
  if [[ "${line}" =~ ^v[0-9]+.[0-9]+.[0-9]+$ ]]; then
    echo "TARGET: ${line}"
    TARGETS+=("${line}")
  fi
  for pattern in "${PATTERNS[@]}"; do
    echo "${line}" "<>" "${pattern}"
    if [[ "${line}" =~ ${pattern} ]]; then
      echo "TARGET: ${line}"
      TARGETS+=("${line}")
    fi
  done
done < <(echo "${TAGS}")

echo "TARGETS: ${TARGETS[*]}"

for target in "${TARGETS[@]}"; do
  echo "Build document from ${PROJECT}:${target}"
  _="$(cd "${PROJECT}" && git checkout "${target}")"
  PRJ="${PROJECT}"
  TAG="${target}"
  DATE="$(cd "${PROJECT}" && git for-each-ref --format="%(taggerdate:short)" refs/tags/"${target}")"
  make build PRJ="${PRJ}" TAG="${TAG}" DATE="${DATE}"
done

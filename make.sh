#! /bin/bash

# Input variables.
# PROJECT="aileron-test"
# PATTERNS=()

# Initialize.
git clone "https://github.com/aileron-project/${PROJECT}.git"
TAGS=$(cd "${PROJECT}" && git tag)

# Show all available tags.
echo "--------------------"
echo "TAGS"
echo "${TAGS}"
echo "--------------------"

# Select target tags.
TARGETS=()
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

# Show target tags.
echo "TARGETS: ${TARGETS[*]}"

# Generate documents from HEAD.
PRJ="${PROJECT}"
TAG="main"
DATE=$(cd "${PROJECT}" && git log -1 --format=%cd --date=format:"%Y-%m-%d")
make build PRJ="${PRJ}" TAG="${TAG}" DATE="${DATE}"

# Generate documents from tags.
for target in "${TARGETS[@]}"; do
  echo "Build document from ${PROJECT}:${target}"
  _=$(cd "${PROJECT}" && git checkout "${target}")
  PRJ="${PROJECT}"
  TAG="${target}"
  DATE=$(cd "${PROJECT}" && git for-each-ref --format="%(taggerdate:short)" refs/tags/"${target}")
  make build PRJ="${PRJ}" TAG="${TAG}" DATE="${DATE}"
done

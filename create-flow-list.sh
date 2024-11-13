#!/usr/bin/env bash

if ! compgen -G "./setup-*.sh" &> /dev/null; then
  echo "$0: target script is not found." >&2
  exit 1
fi

echo "[checking with bash]"
if ! bash -n ./setup-*.sh; then
  exit 1
fi

echo "[checking with shellcheck]"
if command -v shellcheck &> /dev/null; then
  if ! shellcheck ./setup-*.sh; then
    exit 1
  fi
fi

: >> README.md
sed '/^## Flow/,$d' README.md > _
mv _ README.md

echo '## Flow
```txt
'"$(
  sed -n 's/^wait_enter  *(\1) *&&.*$/\1/p' ./setup-*.sh | tr -d \'
)"'
```'

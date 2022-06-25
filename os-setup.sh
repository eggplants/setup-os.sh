#!/usr/bin/env bash

readonly INSTALL_WAIT_OFF="${1-0}"

function cmd_exist() {
  if command -v "$1" &> /dev/null; then
    echo "${1}: command already exists" >&2
    return 0
  fi
  return 1
}

function file_exist() {
  if [ -f "$1" ]; then
    echo "${1}: file already exists" >&2
    return 0
  fi
  return 1
}

function wait_enter() {
  if [[ "$INSTALL_WAIT_OFF" = 1 ]]; then
    return 0
  fi
  for ((i = 0; i++ < 3; )); do
    printf '%0*d\n' "$i"{,} | tr 0-9 v
    sleep 0.15
  done
  if [ $# -eq 0 ]; then
    echo -n '[ENTER]'
    read -r
  else
    echo -n "[${*} - ENTER Y/n]:"
    read -r resp
    if [[ "$resp" =~ Y|y ]]; then
      return 0
    else
      return 1
    fi
  fi
}

# Example:
#
# wait_enter "install foo" && (
#   cmd_exist foo && exit
#   bar install foo
# )

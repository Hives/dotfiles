#!/bin/bash
# Removes old revisions of snaps
# CLOSE ALL SNAPS BEFORE RUNNING THIS
# taken from https://www.debugpoint.com/clean-up-snap/
set -eu
LANG=en_US.UTF-8 snap list --all | awk '/disabled/{print $1, $3}' |
  while read snapname revision; do
    # echo "${snapname} ${revision}"
    snap remove "$snapname" --revision="$revision"
  done

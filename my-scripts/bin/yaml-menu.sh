#! /usr/bin/env bash

set -e -o pipefail

menu_file=$1

list_to_value_filter="s/^- \(.*\)$/\1/p"

selected=$(cat $menu_file | yq 'map(.name)' | sed -n "${list_to_value_filter}" | launcher)

cat $menu_file | yq ".[] | select(.name == \"$selected\").value"

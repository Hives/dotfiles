#! /usr/bin/env bash

# requires menu.sh script

set -e -o pipefail

menu_file=$1

# this is not very scientific - would be better remove only first and last
# quote and de-escape quoted quotes
function remove_quotes {
    echo $1 | tr -d '"'
}

object=$(cat $menu_file)

function make_selection {
    key=$(echo $object | jq -c keys | jq -c '.[]' | menu.sh)
    key_unquoted=$(remove_quotes $key)

    object=$(echo $object | jq ".${key_unquoted}")

    type=$(echo $object | jq -c 'type')

    if [[ $type == '"object"' ]]; then
        make_selection
    fi
}

make_selection

echo $(remove_quotes $object)

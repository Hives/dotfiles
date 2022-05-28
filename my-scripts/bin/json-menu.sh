#! /usr/bin/env bash

# requires launcher script - misnamed for this context

set -e -o pipefail

menu_file=$1

path=()

# this is not very scientific - would be better remove only first and last
# quote and de-escape quoted quotes
function remove_quotes {
    echo $1 | tr -d '"'
}

function select_keys {
    object=$(cat $menu_file)

    for path_segment in "${path[@]}"; do
        # warning - breaks if certain characters in the key, e.g. "-"
        object=$(echo $object | jq ".${path_segment}")
    done

    type=$(echo $object | jq -c 'type')

    if [[ $type != '"object"' ]]; then
        return
    fi

    new_path_segment=$(echo $object | jq -c keys | jq -c '.[]' | launcher)

    path+=($(remove_quotes $new_path_segment))

    select_keys
}

select_keys

echo $(remove_quotes $object)

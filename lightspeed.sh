#!/bin/bash
function check_status {
    status=$1
    #ok_length=$(echo $status | wc -c |  tr -d " ")
    if [[ $status == "OK" ]]; then
        echo 0
    else 
        echo 1
    fi
}

function get_statuses {
    url=$1
    file=$2
    status_code=$(curl -s -I $url | head -n1 | grep 200)
    if [[ -z $status_code ]]; then
        echo "ERROR getting statuses" 
        exit 1
    else
        curl -s $url > $file
    fi
}

function parse_file {
    file=$1
    status=0
    IFS=":"
    while read line; do
        if [[ $line != "" ]]; then
            IFS=': ' read -r -a array <<< "$line"
            if [[ $(check_status ${array[1]}) == "1" ]]; then
                echo "The service ${array[0]} is ${array[1]} ${array[2]}"
                status=1
            fi
        fi
    done < $file
    exit $status
}

URL=$1
FILE=$2

get_statuses $URL $FILE
parse_file $FILE
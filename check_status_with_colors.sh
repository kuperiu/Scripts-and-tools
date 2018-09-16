#!/bin/bash

bold=`tput bold`
black=`tput setaf 0` #   0  Black
red=`tput setaf 1`  # 	1	Red
green=`tput setaf 2`  # 	2	Green
yellow=`tput setaf 3`  # 	3	Yellow
blue=`tput setaf 4`  # 	4	Blue
magenta=`tput setaf 5`  # 	5	Magenta
cyan=`tput setaf 6`  # 	6	Cyan
white=`tput setaf 7`  # 	7	White
reset=`tput sgr0`

function which_color() {
    color=$white
    res=$1
    if [ "$res" == "true" ]; then
         color=$green
    elif [ "$res" == "false" ]; then
         color=$res
    else
         color=$yellow
    fi
    echo $color
}

function print_res() {
    url=$1
    res=$2
    longest_line=$3
    color=$(which_color $res)
    line_length=$(echo $url | wc -c)
    space=$(( $longest_line - $line_length + 50 ))
    printf "%s %*s %s\n" $reset$url $space $bold$color$res
}

function get_status() {
    file_name=$1
    env=$2
    longest_line=$(cat $file_name|awk '{print length}'|sort -nr|head -1)
    while read url; do 
        res=$(curl -s -u OpsView:opsview_zetes491602 https://mon.atlas.${env}16.cldsvc.net/$url)
        print_res $url $res $longest_line
    done < $file_name
}

get_status endpoints.txt $1

#!/bin/bash

<<COMMENT
top uri implementation in bash
to test stdin do:
echo apache.log | ./top_uris.sh 10
COMMENT

lines=()
while read line; do
    lines+=($(echo $line | awk '{print $7}'))
done < $(cat /dev/stdin)

printf '%s\n' "${lines[@]}" | sort | uniq -c | sort -r | head -n$1

####with colors
#cat apache.log | awk '{print $7}' | sort | uniq -c | sort -r | head | awk '{print "\033[32m"$1 " "  "\033[36m"$2}'
# 30 - black   34 - blue          
#    31 - red     35 - magenta       
#    32 - green   36 - cyan          
#    33 - yellow  37 - white    
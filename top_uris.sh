#!/bin/bash

<<COMMENT
top uri implementation in bash
to test stdin do:
echo apache.log | ./top_uris.sh
COMMENT

lines=()
while read line; do
    lines+=($(echo $line | awk '{print $7}'))
done < $(cat /dev/stdin)

printf '%s\n' "${lines[@]}" | sort | uniq -c | sort -r | head -n4
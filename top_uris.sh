#!/bin/bash

lines=()
while read line; do
    lines+=($(echo $line | awk '{print $7}'))
done < $(cat /dev/stdin)


printf '%s\n' "${lines[@]}" | sort | uniq -c | sort -r | head -n4
#!/usr/bin/env python
import sys
import operator
import argparse

def print_top_uris(uris, num):
    for i in range(num):
        uri = uris[i][0]
        count = uris[i][1]
        print "{} -- {}".format(uri,count)

def sort_uris(uris):
    sorted_uris = list(reversed(sorted(uris.items(), key=operator.itemgetter(1))))
    return sorted_uris


def find_duplicates(uris, uri):
    if uri not in uris:
        uris[uri] = 1
    else:
        uris[uri] += 1
    return uris


def get_top_uris(log_file, num):
    uris = {}
    with open(log_file,'r') as fp:
        lines = fp.readlines()
        for line in lines:
            splited_line = line.split(" ")
            uri = splited_line[6]
            uri = find_duplicates(uris, uri)
        
        sorted_uris =  sort_uris(uris)
        print_top_uris(sorted_uris, num)
        

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-l', '--log', help='log file path', required=True)
    parser.add_argument('-t', '--top', help='Number of top uris to print', required=True)
    args = parser.parse_args()

    get_top_uris(args.log, int(args.top))
if __name__ == '__main__':
  main()


##how to do it bash##
#cat apache.log | awk '{print $7}' | sort | uniq -c | sort -r | head -n4
#####################

##and with stdin
# lines=()
# while read line; do
#     lines+=($(echo $line | awk '{print $7}'))
# done < $(cat /dev/stdin)

# printf '%s\n' "${lines[@]}" | sort | uniq -c | sort -r | head -n4
#####
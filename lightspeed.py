#!/usr/bin/env python
import sys
import json
import requests
import argparse

#check if status is truly ok with no substring for say
def check_status_ok(status):
    if status == "OK":
        return True
    else:
        return False


#parse the text into keys and valuse and check the status of the service
def get_list(text):
    lines = text.split("\n")
    is_error = False
    for line in lines:
        if len(line) != 0:
            name,status = line.split(":")
            status = status[1:]
            if not check_status_ok(status):
                is_error = True
                print "The service {} is {}.".format(name, status)

    if is_error:
        raise Exception("found error/s")


#check if we get 200 status ok from the url
def get_response(url):
    try:
         response = requests.get(url)
    except Exception as e:
        raise(e)
    return response.text


#get the body from url 
def get_status(text):
    try:
        get_list(text)
    except Exception as e:
        raise(e)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-a', '--address', help='url', required=True)
    args = parser.parse_args()
    try:
        text = get_response(args.address)
        get_list(text)
    except Exception as e:
        print e
        exit(1)
if __name__ == '__main__':
  main()
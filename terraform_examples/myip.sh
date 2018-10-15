#!/bin/bash
set -e
my_ip=$(curl https://v4.ident.me/json)
jq -n --arg my_ip "$my_ip" '{"my_ip":$my_ip}'
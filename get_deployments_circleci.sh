#!/bin/bash

usage(){
	echo "no job name as an argument supplied"
	exit 1
}

[[ $# -eq 0 ]] && usage

CIRCLE_JOB=$1
VCS=""
ORG=""
REPO=""
BRANCH=""
curl -s "https://circleci.com/api/v1.1/project/${VCS}/${ORG}/${REPO}/tree/${BRANCH}?circle-token={$CIRCLECI}&limit=30" | \
jq ". | select(.[].build_parameters.CIRCLE_JOB==\"${CIRCLE_JOB}\") | \
.[] | {user: .user[\"name\"],status,start_time}" | \
jq -r '. | [.user, .status, .start_time] | @tsv' 

#!/usr/bin/env python
import sys
import json
from collections import Counter
import requests
import boto3

def check_shard_redundancy(zones_arr):
    '''checks if each shard has at least 3 replicas and that at least
    1 of the replicas is in a different AZ'''
    if len(zones_arr) < 3 or len(Counter(zones_arr)) < 2:
        sys.exit(1)

def get_availability_zone(internal_ip):
    '''gets the name of a replica and return the AZ of the replicas
    we cut the replica name so we'll get the internal ip of the replica's instance'''
    ip = internal_ip[:-10]
    client = boto3.client('ec2')
    instance = client.describe_instances(Filters=[{'Name':'private-ip-address', 'Values':[ip]}])
    return instance['Reservations'][0]['Instances'][0]['Placement']['AvailabilityZone']

def get_json(url):
    '''get the cluster status json from solr cloud'''
    response = requests.get(url)
    data = json.loads(response.text)
    return data

def get_replicas(data):
    '''parse a json and put replicas of each shard in a single array'''
    if type(data) != dict:
        return
    elif 'node_name' in data:
        return data['node_name']
    else:
        replicas = []
        for key in data:
            res = get_replicas(data[key])
            if res is not None:
                replicas.append(get_replicas(data[key]))
        if len(replicas) != 0:
            check_shard_redundancy(replicas)

#url = 'http://ipaddress:8983/solr/admin/collections?action=CLUSTERSTATUS&wt=json'
url = ''
data = get_json(url)
get_replicas(data)

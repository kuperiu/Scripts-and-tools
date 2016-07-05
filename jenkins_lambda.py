from __future__ import print_function

import json
import boto3


resource = boto3.resource('ec2')
client = boto3.client('ec2')

def get_instance_id(tag):
    try:
        instances = resource.instances.filter(Filters=[{'Name': 'tag:Name', 'Values': [tag]}])
        for instance in instances:
            return instance.instance_id
    except Exception as e:
        print(e)
        return False

def get_volume_id(instance_id):
    try:
        devices = resource.Instance(instance_id).block_device_mappings
        for device in devices:
            if device['DeviceName'] == '/dev/sdf':
                return device['Ebs']['VolumeId']
    except Exception as e:
        print(e)
        return False

def set_snapshot(volume_id):
    try:
        volume = resource.Volume(volume_id)
        snapshot = volume.create_snapshot()
        snapshot.wait_until_completed()
        return snapshot.snapshot_id
    except Exception as e:
        print(e)
        return False

def set_volume(snapshot_id):
    try:
        new_volume = client.create_volume(
         Size = 1,
         SnapshotId = snapshot_id,
         AvailabilityZone = 'us-west-2b',
         VolumeType= 'gp2'
         )
        waiter = client.get_waiter('volume_available')
        waiter.wait(
         VolumeIds=[
          new_volume['VolumeId']
         ]
        )
        return new_volume['VolumeId']
    except Exception as e:
        print(e)
        return False

def detach_volume(volume_id):
    try:
        client.detach_volume(
         VolumeId = volume_id
         )
        waiter = client.get_waiter('volume_available')
        waiter.wait(
        VolumeIds=[
         volume_id
         ]
        )
    except Exception as e:
        print(e)
        return False

def attach_volume(instance_id, volume_id):
    try:
        client.attach_volume(
         VolumeId = volume_id,
         InstanceId = instance_id,
         Device = '/dev/sdf'
         )
    except Exception as e:
        print(e)
        return False

def delete_snapshot(snapshot_id):
    try:
        client.delete_snapshot(
         SnapshotId = snapshot_id
        )
    except Exception as e:
        print(e)
        return False

def delete_volume(volume_id):
    try:
        client.delete_volume(
         VolumeId = volume_id
         )
    except Exception as e:
        print(e)
        return False

def lambda_handler(event, context):
    active_instance_id = get_instance_id('jenkins')
    active_volume_id = get_volume_id(active_instance_id)
    snapshot_id = set_snapshot(active_volume_id)
    new_volume_id = set_volume(snapshot_id)

    passive_instance_id = get_instance_id('jenkins-backup')
    passive_volume_id = get_volume_id(passive_instance_id)
    detach_volume(passive_volume_id)
    attach_volume(passive_instance_id, new_volume_id)
    delete_snapshot(snapshot_id)
    delete_volume(passive_volume_id)

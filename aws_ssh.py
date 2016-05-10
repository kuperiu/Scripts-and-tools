#!/usr/bin/env python
import boto3,optparse,subprocess,sys

'''
connects to an ec2 instance by a tag name
Before run:
1. pip install boto3
2. aws configure
'''

def get_public_ip(tag):
    ec2 = boto3.resource('ec2')
    instances = ec2.instances.filter(Filters=[{'Name': 'tag:Name', 'Values': [tag]}])
    for instance in instances:
        return instance.public_ip_address
    print("Tag name was not found")


def main():
  p = optparse.OptionParser(description='Connect to an EC2 instance by a tag name')
  p.add_option('-t', '--tag', action ='store', help='Tag name')
  p.add_option('-i', '--certificate', action ='store', help='Certificate path')
  options, arguments = p.parse_args()
  if options.tag and options.certificate:
      ip = get_public_ip(options.tag)
      cmd = 'ssh ubuntu@' + ip + ' -i ' + options.certificate
      subprocess.call(cmd,shell=True)
  else:
      print('Missing arguments')

if __name__ == '__main__':
  main()

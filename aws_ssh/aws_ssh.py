#!/usr/bin/env python
import boto3,argparse,subprocess,sys

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
    sys.exit(1)


def main():
    parser = argparse.ArgumentParser(description="Connect to an EC2 instance by a tag name")
    parser.add_argument("-t", "--tag", action="store", help="The tag name of the EC2 instance ")
    parser.add_argument("-i", "--certificate", action="store",help="The key location")
    args = parser.parse_args()
    if args.tag and args.certificate:
        ip = get_public_ip(args.tag)
        cmd = 'ssh ubuntu@' + ip + ' -i ' + args.certificate
        subprocess.call(cmd,shell=True)
    elif not args.tag:
        print("Tag name is missing")
    else:
        print("Certificate location is missing")
if __name__ == '__main__':
  main()

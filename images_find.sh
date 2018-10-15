#!/bin/bash
aws ec2 describe-images --region eu-west-1 --filters Name=name,Values=*$1* --query "Images[*].[ImageId,Name]" --output table --profile default
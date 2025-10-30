#!/bin/bash

# Get VPC ID from terraform output
VPC_ID=$(cd terraform/phase-1-network && terraform output -raw vpc_id)

echo "Your VPC ID is: $VPC_ID"

# Use it in AWS CLI command
aws ec2 describe-vpcs --vpc-ids $VPC_ID --query 'Vpcs[0].CidrBlock' --output text


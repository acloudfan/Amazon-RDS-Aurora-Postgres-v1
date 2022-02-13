#!/bin/bash
#Creates a subnet group
#https://docs.aws.amazon.com/cli/latest/reference/dms/create-replication-subnet-group.html

REPL_SUBNET_GROUP_ID=rdsa-dms-subnet-group
# Get the private subnet list from the CloudFormation output
RDSA_VPC_CF_STACK_NAME="rdsa-vpc"
VPC_PRIVATE_SUBNETS=$(aws cloudformation  describe-stacks --stack-name $RDSA_VPC_CF_STACK_NAME --query 'Stacks[0].Outputs[?OutputKey==`PrivateSubnets`].OutputValue | [0]' --output text)

# Replace ',' with space
VPC_PRIVATE_SUBNETS=$(echo ${VPC_PRIVATE_SUBNETS//,/ })

# Create the subnet group
aws dms create-replication-subnet-group  \
    --replication-subnet-group-identifier  $REPL_SUBNET_GROUP_ID   \
    --replication-subnet-group-description  'Used for DMS Repl instances' \
    --subnet-ids $VPC_PRIVATE_SUBNETS


if  [ $? == 0 ]; then
    echo 'Done.'
else
    echo 'Failed !!!'
fi

#!/bin/bash
# Creates the RDSA PG Cluster 
# DEPENDENCY on CloudFormation Stack: rdsa-vpc

RDSA_VPC_CF_STACK_NAME="rdsa-vpc"
RDSA_CLUSTER_CF_STACK_NAME="rdsa-postgresql"
TEMPLATE_LOCATION=file://home/ec2-user/cloudformation/rdsa-postgresql.yml \

# Get the comma seperated list of subnets
VPC_ID=$(aws cloudformation  describe-stacks --stack-name rdsa-vpc --query 'Stacks[0].Outputs[?ExportName==`us-east-2-rdsa-vpc-MainVPC`].OutputValue | [0]')
PRIVATE_SUBNETS=$(aws cloudformation  describe-stacks --stack-name rdsa-vpc --query 'Stacks[0].Outputs[?ExportName==`rdsa-vpc-SubnetsPrivate`].OutputValue | [0]')

if [ -z "VPC_ID" ]; then
    echo "Looks like the stack rdsa-vpc is not there!!"
    echo "Please check - Aborting :("
    exit
fi

echo "VPC ID = $VPC_ID"
echo "Private Subnet List = $PRIVATE_SUBNETS"

# Get the VPC ID

aws cloudformation create-stack    \  
--stack-name $RDSA_CLUSTER_CF_STACK_NAME   \ 
--template-body $TEMPLATE_LOCATION  \
--parameters ParameterKey=TemplateURLBase,ParameterValue=$S3BUCKET_TEMPLATE_URL
ParameterKey=TemplateName,ParameterValue=$CF_TEMPLATE_NAME
--capabilities "CAPABILITY_NAMED_IAM"
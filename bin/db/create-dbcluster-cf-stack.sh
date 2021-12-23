#!/bin/bash
# Creates the RDSA PG Cluster 
# DEPENDENCY on CloudFormation Stack: rdsa-vpc

RDSA_VPC_CF_STACK_NAME="rdsa-vpc"
RDSA_SG_CF_STACK_NAME="rdsa-security-group"
RDSA_CLUSTER_CF_STACK_NAME="rdsa-postgresql"
TEMPLATE_LOCATION=file://home/ec2-user/cloudformation/rdsa-postgresql.yml \

# Get the comma seperated list of subnets
VPC_ID=$(aws cloudformation  describe-stacks --stack-name $RDSA_VPC_CF_STACK_NAME --query 'Stacks[0].Outputs[?ExportName==`us-east-2-rdsa-vpc-MainVPC`].OutputValue | [0]')
PRIVATE_SUBNETS=$(aws cloudformation  describe-stacks --stack-name $RDSA_VPC_CF_STACK_NAME --query 'Stacks[0].Outputs[?ExportName==`rdsa-vpc-SubnetsPrivate`].OutputValue | [0]')
RDSA_INTERNAL_SG=$(aws cloudformation  describe-stacks --stack-name rdsa-security-group --query 'Stacks[0].Outputs[?OutputKey==`DBSecurityGroupCluster`].OutputValue | [0]')

if [ -z "VPC_ID" ]; then
    echo "Looks like the stack rdsa-vpc is not there!!"
    echo "Please check - Aborting :("
    exit
fi

# Show the info used for 
echo "VPC ID = $VPC_ID"
echo "Private Subnet List = $PRIVATE_SUBNETS"
echo "Security Group = $RDSA_INTERNAL_SG"


aws cloudformation create-stack    \  
--stack-name $RDSA_CLUSTER_CF_STACK_NAME   \ 
--template-body $TEMPLATE_LOCATION  \
--parameters ParameterKey=TemplateName,ParameterValue="$RDSA_CLUSTER_CF_STACK_NAME"  \
ParameterKey=TemplateName,ParameterValue=RdsAuroraVPC,ParameterValue="$VPC_ID"  \
ParameterKey=PrivateSubnets,ParameterValue="$PRIVATE_SUBNETS" \
ParameterKey=DBMasterUsername,ParameterValue="masteruser" \
ParameterKey=DBMasterUserPassword,ParameterValue="masteruserpw" \
ParameterKey=VPCSecurityGroupCluster,ParameterValue="$RDSA_INTERNAL_SG" \
--capabilities "CAPABILITY_NAMED_IAM"
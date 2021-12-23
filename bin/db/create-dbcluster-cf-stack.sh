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

# Create the stack
aws cloudformation create-stack    \  
--stack-name "$RDSA_CLUSTER_CF_STACK_NAME"   \ 
--template-body "$TEMPLATE_LOCATION"  \
--parameters ParameterKey=TemplateName,ParameterValue="$RDSA_CLUSTER_CF_STACK_NAME"  \
ParameterKey=TemplateName,ParameterValue=RdsAuroraVPC,ParameterValue="$VPC_ID"  \
ParameterKey=PrivateSubnets,ParameterValue="$PRIVATE_SUBNETS" \
ParameterKey=DBMasterUsername,ParameterValue="masteruser" \
ParameterKey=DBMasterUserPassword,ParameterValue="masteruserpw" \
ParameterKey=VPCSecurityGroupCluster,ParameterValue="$RDSA_INTERNAL_SG" \
--capabilities "CAPABILITY_NAMED_IAM"

while [ $? == 0 ]; do
    SLEEP 5
    STATUS=$(aws  cloudformation describe-stacks --stack-name rdsa-postgresql --query 'Stacks[0].StackStaus')
    if [ $STATUS == "CREATE_IN_PROGRESS" ]]; then
        echo -n "."
    else
        break
    fi
done;

# If no error
CF_STACK_STATUS=$(aws  cloudformation describe-stacks --stack-name rdsa-postgresql --query 'Stacks[0].StackStaus')
DB_CLUSTER_STATUS=$(aws rds describe-db-clusters  --db-cluster-identifier "$DB_CLUSTER_ID"   --query 'DBClusters[0].Status')

echo "Current status of CF Stack: $CF_STACK_STATUS"
echo "Current status of DB Cluster: $DB_CLUSTER_STATUS"
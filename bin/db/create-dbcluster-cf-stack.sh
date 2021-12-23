#!/bin/bash
# Creates the RDSA PG Cluster 
# DEPENDENCY on CloudFormation Stack: rdsa-vpc



RDSA_VPC_CF_STACK_NAME="rdsa-vpc"
RDSA_SG_CF_STACK_NAME="rdsa-security-group"
RDSA_CLUSTER_CF_STACK_NAME="rdsa-postgresql"
TEMPLATE_LOCATION=file:///home/ec2-user/cloudformation/postgres-cluster.yml \
SLEEP_TIME=5

# Check if the stack already exists
RDSA_PG_STACK=$(aws cloudformation  describe-stacks --stack-name $RDSA_VPC_CF_STACK_NAME --query 'Stacks[0].Outputs[?ExportName==`us-east-2-rdsa-vpc-MainVPC`].OutputValue | [0]')
# Check if the stack already exists
RDSA_PG_STACK=$(aws cloudformation  describe-stacks --stack-name $RDSA_VPC_CF_STACK_NAME --query 'Stacks[0].Outputs[?ExportName==`us-east-2-rdsa-vpc-MainVPC`].OutputValue | [0]')
if [ $? == 0 ]; then
   echo "Stack [$RDSA_PG_STACK] already exist!!"
   echo "Aborting."
   exit
fi


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
echo "CF Stack Name = $RDSA_CLUSTER_CF_STACK_NAME"

# Create the stack
aws cloudformation create-stack \
--stack-name "$RDSA_CLUSTER_CF_STACK_NAME" --template-body "$TEMPLATE_LOCATION"  \
--parameters ParameterKey=TemplateName,ParameterValue="$RDSA_CLUSTER_CF_STACK_NAME"  \
ParameterKey=RdsAuroraVPC,ParameterValue="$VPC_ID"  \
ParameterKey=PrivateSubnets,ParameterValue="$PRIVATE_SUBNETS" \
ParameterKey=DBMasterUsername,ParameterValue="masteruser" \
ParameterKey=DBMasterUserPassword,ParameterValue="masteruserpw" \
ParameterKey=VPCSecurityGroupCluster,ParameterValue="$RDSA_INTERNAL_SG" \
--capabilities "CAPABILITY_NAMED_IAM"

while [ $? == 0 ]; do
    sleep $SLEEP_TIME
    CF_STACK_STATUS=$(aws  cloudformation describe-stacks --stack-name $RDSA_CLUSTER_CF_STACK_NAME --output text --query 'Stacks[0].StackStatus')
    if [[ $CF_STACK_STATUS == "CREATE_IN_PROGRESS" ]]; then
        echo -n "."
    else
        break
    fi
done;
echo "."

# If no error
DB_CLUSTER_STATUS=$(aws rds describe-db-clusters  --db-cluster-identifier "$DB_CLUSTER_ID"   --query 'DBClusters[0].Status')

echo "Current status of CF Stack: $CF_STACK_STATUS"
echo "Current status of DB Cluster: $DB_CLUSTER_STATUS"
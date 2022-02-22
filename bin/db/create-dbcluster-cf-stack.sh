#!/bin/bash
# Creates the RDSA PG Cluster 
# DEPENDENCY on CloudFormation Stack: rdsa-vpc
# ./bin/db/create-db-cluster-cf-stack.sh  [instance-class Default = db.t3.medium] [PostgreSQL-Version = 13.4]



RDSA_VPC_CF_STACK_NAME="rdsa-vpc"
RDSA_SG_CF_STACK_NAME="rdsa-security-group"
RDSA_CLUSTER_CF_STACK_NAME="rdsa-postgresql"
TEMPLATE_LOCATION=file:///home/ec2-user/cloudformation/postgres-cluster.yml \
SLEEP_TIME=5

# Check if the stack already exists
RDSA_PG_STACK_STATUS=$(aws cloudformation  describe-stacks --stack-name $RDSA_CLUSTER_CF_STACK_NAME --query 'Stacks[0].StackStatus')
if [ $? == 0 ]; then
   echo "Stack [$RDSA_CLUSTER_CF_STACK_NAME=$RDSA_PG_STACK_STATUS] already exist!!"
   echo "Aborting."
   exit
fi


# Get the comma seperated list of subnets
VPC_ID=$(aws cloudformation  describe-stacks --stack-name $RDSA_VPC_CF_STACK_NAME --query 'Stacks[0].Outputs[?OutputKey==`MainVPC`].OutputValue | [0]')

PRIVATE_SUBNETS=$(aws cloudformation  describe-stacks --stack-name $RDSA_VPC_CF_STACK_NAME --query 'Stacks[0].Outputs[?OutputKey==`PrivateSubnets`].OutputValue | [0]')

RDSA_INTERNAL_SG=$(aws cloudformation  describe-stacks --stack-name rdsa-security-group --query 'Stacks[0].Outputs[?OutputKey==`DBSecurityGroupCluster`].OutputValue | [0]')

if [ -z "VPC_ID" ]; then
    echo "Looks like the stack rdsa-vpc is not there!!"
    echo "Please check - Aborting :("
    exit
fi


# This will set the version
if [ -z "$2" ]; then
    DB_ENGINE_VERSION=13.4
else
    DB_ENGINE_VERSION=$2
fi

# Show the info used for 
echo "VPC ID = $VPC_ID"
echo "Private Subnet List = $PRIVATE_SUBNETS"
echo "Security Group = $RDSA_INTERNAL_SG"
echo "CF Stack Name = $RDSA_CLUSTER_CF_STACK_NAME"

# Instance class
DB_INSTANCE_CLASS=db.t3.medium
if [ -z "$1" ]; then
    echo  "Instance Class = (default) $DB_INSTANCE_CLASS"
else 
    DB_INSTANCE_CLASS=$1
    echo  "Instance Class = $DB_INSTANCE_CLASS"
fi

# Create the stack
aws cloudformation create-stack \
--stack-name "$RDSA_CLUSTER_CF_STACK_NAME" --template-body "$TEMPLATE_LOCATION"  \
--parameters ParameterKey=TemplateName,ParameterValue="$RDSA_CLUSTER_CF_STACK_NAME"  \
ParameterKey=RdsAuroraVPC,ParameterValue="$VPC_ID"  \
ParameterKey=PrivateSubnets,ParameterValue="$PRIVATE_SUBNETS" \
ParameterKey=DBMasterUsername,ParameterValue="masteruser" \
ParameterKey=DBMasterUserPassword,ParameterValue="masteruserpw" \
ParameterKey=DBEngineVersion,ParameterValue="$DB_ENGINE_VERSION" \
ParameterKey=VPCSecurityGroupCluster,ParameterValue="$RDSA_INTERNAL_SG" \
ParameterKey=DBInstanceClass,ParameterValue="$DB_INSTANCE_CLASS" \
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
echo "Make sure to reset Bastion host environment: "
echo "                   (1)./bin/setup-env.sh <your-aws-region> "
echo "                   (2) Log out & Log back in"
echo "Done."
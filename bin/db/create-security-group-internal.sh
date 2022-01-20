#!/bin/bash
#Creates the security group used by the DB instances

RDSA_SG_CF_STACK_NAME="rdsa-security-group"
RDSA_VPC_CF_STACK_NAME="rdsa-vpc"

TEMPLATE_LOCATION=file:///home/ec2-user/cloudformation/security-group.yml \

SLEEP_TIME=3s

# Check if the stack already exists
RDSA_PG_STACK_STATUS=$(aws cloudformation  describe-stacks --stack-name $RDSA_SG_CF_STACK_NAME --query 'Stacks[0].StackStatus')
if [ $? == 0 ]; then
   echo "Stack [$RDSA_SG_CF_STACK_NAME=$RDSA_SG_CF_STACK_NAME] already exist!!"
   echo "Aborting."
   exit
fi

# Get the VPC ID
VPC_ID=$(aws cloudformation  describe-stacks --stack-name $RDSA_VPC_CF_STACK_NAME --query 'Stacks[0].Outputs[?OutputKey==`MainVPC`].OutputValue | [0]')
echo $VPC_ID

if [ -z "VPC_ID" ]; then
    echo "Looks like the stack rdsa-vpc is not there!!"
    echo "Please check - Aborting :("
    exit
fi

# Create the stack
aws cloudformation create-stack \
--stack-name "$RDSA_SG_CF_STACK_NAME" --template-body "$TEMPLATE_LOCATION"  \
--parameters ParameterKey=RdsAuroraVPC,ParameterValue="$VPC_ID"  \
--capabilities "CAPABILITY_NAMED_IAM"

while [ $? == 0 ]; do
    sleep $SLEEP_TIME
    CF_STACK_STATUS=$(aws  cloudformation describe-stacks --stack-name $RDSA_SG_CF_STACK_NAME --output text --query 'Stacks[0].StackStatus')
    if [[ $CF_STACK_STATUS == "CREATE_IN_PROGRESS" ]]; then
        echo -n "."
    else
        break
    fi
done;
echo "."

echo "Done."

#!/bin/bash
#Creates the security group used by the DB instances

RDSA_SG_CF_STACK_NAME="rdsa-security-group"

# Delete the stack
aws cloudformation delete-stack --stack-name "$RDSA_SG_CF_STACK_NAME"

# Continuously check the delete status
while [ $? == 0 ]; do
    sleep 5
    STATUS=$(aws  cloudformation describe-stacks --output text --stack-name "$RDSA_SG_CF_STACK_NAME" --query 'Stacks[0].StackStatus')
    if [[ "$STATUS" == "DELETE_IN_PROGRESS" ]]; then
        echo -n "."
    else
        break
    fi
done;
echo "."

echo "Done."

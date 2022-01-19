#!/bin/bash
#Creates the security group used by the DB instances

RDSA_SG_CF_STACK_NAME="rdsa-security-group"

# Delete the stack
aws cloudformation delete-stack --stack-name "$RDSA_SG_CF_STACK_NAME"

echo "Done."

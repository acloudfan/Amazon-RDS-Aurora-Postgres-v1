#!/bin/bash
#This script assumes the role  IAM_DBUSER_ROLE

IAM_DBUSER_ROLE=rdsa-iam-dbuser-role
IAM_DBUSER_ROLE_ARN=$(aws iam list-roles --query "Roles[?RoleName=='$IAM_DBUSER_ROLE'].Arn" --output text)


ENV_VARS_JSON=$(aws sts assume-role --role-arn "$IAM_DBUSER_ROLE_ARN" --role-session-name AWSCLI-DBUser-Session)


echo "Setting up the environment variables in the shell."

export AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' <<< $ENV_VARS_JSON )
export AWS_SECRET_ACCESS_KEY=$(jq -r '.Credentials.SecretAccessKey' <<< $ENV_VARS_JSON )
export AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken' <<< $ENV_VARS_JSON )

echo "Please validate identity. Is it set to assumed-role/rdsa-iam-dbuser-role/AWSCLI-DBUser-Session ?"
echo "If NOT then you missed the keword 'source' before the script name - run again  'source assume-role.sh'"
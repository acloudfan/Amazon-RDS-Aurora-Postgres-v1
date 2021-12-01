#!/bin/bash
# This script assumes the role  IAM_DBUSER_ROLE
# MUST be used with 'source' so that environment vars set in the shell
#   source   assume-dbuser-role.sh    

# Standard IAM dbuser role 
IAM_DBUSER_ROLE=rdsa-iam-dbuser-role
IAM_DBUSER_ROLE_ARN=$(aws iam list-roles --query "Roles[?RoleName=='$IAM_DBUSER_ROLE'].Arn" --output text)

# Assume role provides the JSON with environment vars
ENV_VARS_JSON=$(aws sts assume-role --role-arn "$IAM_DBUSER_ROLE_ARN" --role-session-name AWSCLI-DBUser-Session)

# Extract env vars from JSON and set them in the shell
echo "Setting up the environment variables in the shell."
export AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' <<< $ENV_VARS_JSON )
export AWS_SECRET_ACCESS_KEY=$(jq -r '.Credentials.SecretAccessKey' <<< $ENV_VARS_JSON )
export AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken' <<< $ENV_VARS_JSON )

# Dump the caller identity - it should be the DB user
# aws sts get-caller-identity

echo "Please validate identity on shell prompt by running command 'aws sts get-caller-identity' "
echo "         Is it is not assumed-role/rdsa-iam-dbuser-role/AWSCLI-DBUser-Session ?"
echo "If NOT then you missed the keword 'source' before the script name - run again  'source assume-role.sh'"

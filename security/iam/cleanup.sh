#!/bin/bash
# Cleanup IAM
#   1. DB User Policy
#   2. DB User Role

IAM_DBUSER_POLICY=rdsa-iam-dbuser-policy
IAM_DBUSER_ROLE=rdsa-iam-dbuser-role

IAM_DBUSER_POLICY_ARN=$(aws iam list-policies --query "Policies[?PolicyName=='$IAM_DBUSER_POLICY'].Arn" --output text)
IAM_DBUSER_ROLE_ARN=$(aws iam list-roles --query "Roles[?RoleName=='$IAM_DBUSER_ROLE'].Arn" --output text)

# detach the policy from role
aws iam detach-role-policy --role-name $IAM_DBUSER_ROLE --policy-arn $IAM_DBUSER_POLICY_ARN

# delete the role
aws iam delete-role --role-name $IAM_DBUSER_ROLE

# delete the policy
aws iam delete-policy --policy-arn $IAM_DBUSER_POLICY_ARN


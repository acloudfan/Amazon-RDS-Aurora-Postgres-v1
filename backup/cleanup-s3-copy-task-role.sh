#!/bin/bash
# Cleanup IAM
#   1. DB User Policy
#   2. DB User Role

IAM_COPY_TASK_POLICY=rdsa-copy-to-s3-task-policy
IAM_COPY_TASK_ROLE=rdsa-copy-to-s3-task-role

IAM_COPY_TASK_POLICY_ARN=$(aws iam list-policies --query "Policies[?PolicyName=='$IAM_COPY_TASK_POLICY'].Arn" --output text)
IAM_COPY_TASK_ROLE_ARN=$(aws iam list-roles --query "Roles[?RoleName=='$IAM_COPY_TASK_ROLE'].Arn" --output text)

# detach the policy from role
echo "Detaching the  IAM_COPY_TASK_ROLE"
aws iam detach-role-policy --role-name $IAM_COPY_TASK_ROLE --policy-arn $IAM_COPY_TASK_POLICY_ARN

# delete the role
echo "Deleting the IAM_COPY_TASK_POLICY_ARN from IAM_COPY_TASK_ROLE"
aws iam delete-role --role-name $IAM_COPY_TASK_ROLE

# delete the policy
echo "Deleting the IAM_COPY_TASK_POLICY"
aws iam delete-policy --policy-arn $IAM_COPY_TASK_POLICY_ARN


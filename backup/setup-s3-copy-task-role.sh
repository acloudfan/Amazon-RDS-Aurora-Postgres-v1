#!/bin/bash
# Script sets up a policy and an IAM role

# Check if the two required args were provided
if [ "$#" -ne 1 ]; then
    echo "Aborting !!  Usage: setup-copy-task-role  S3_BUCKET"
    exit
fi

# Sets the args in local vars
S3_BUCKET=$1
AWSREGION=$AWS_DEFAULT_REGION

# If you change the names here then change in the other scripts as well
IAM_COPY_TASK_POLICY=rdsa-copy-to-s3-task-policy
IAM_COPY_TASK_ROLE=rdsa-copy-to-s3-task-role

# Create the IAM policy JSON
read -r -d '' JSON_POLICY << EOL
{
   "Version": "2012-10-17",
   "Statement": [
      {
            "Sid": "ExportPolicy",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject*",
                "s3:ListBucket",
                "s3:GetObject*",
                "s3:DeleteObject*",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::$S3_BUCKET",
                "arn:aws:s3:::$S3_BUCKET/*"
            ]
        }
   ]
}
EOL

# Pretty print JSON to validate the policy
jq <<< $JSON_POLICY

# Get the confirmation that the policy is looking good
read -r -p "Is IAM Policy looking Good? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        echo "Proceeding with Policy creation."
        ;;
    *)
        echo "Aborting !!  Check the arguments."
        exit
        ;;
esac

# Create the policy
aws iam create-policy --policy-name  $IAM_COPY_TASK_POLICY --policy-document "$JSON_POLICY" > /dev/null

# Get the policy ARN
IAM_COPY_TASK_POLICY_ARN=$(aws iam list-policies --query "Policies[?PolicyName=='$IAM_COPY_TASK_POLICY'].Arn" --output text)
echo "IAM_COPY_TASK_POLICY ARN=$IAM_COPY_TASK_POLICY_ARN"

# Create the role trust policy
# This trust policy will allow the Role used for Bastion host to assume the IAM DB Role
BASTION_HOST_ROLE=($(jq -r '.Arn' <<< $(aws sts get-caller-identity)))

read -r -d ''  ASSUME_ROLE_POLICY << EOL
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Principal": {
            "Service": "export.rds.amazonaws.com",
            
          },
        "Action": "sts:AssumeRole"
    }
}
EOL

# Write out the trust policy to temp file
echo "$ASSUME_ROLE_POLICY" > /tmp/assume-policy.json


# Create the role with the trust policy
aws iam create-role --role-name $IAM_COPY_TASK_ROLE --assume-role-policy-document  file:///tmp/assume-policy.json  > /dev/null
IAM_COPY_TASK_ROLE_ARN=$(aws iam list-roles --query "Roles[?RoleName=='$IAM_COPY_TASK_ROLE'].Arn" --output text)
echo "IAM_COPY_TASK_ROLE Arn=$IAM_COPY_TASK_ROLE_ARN"

# Attach the role to policy IAM_COPY_TASK_POLICY
echo "Attaching the DBUSER policy to DBUSER role"
aws iam attach-role-policy   --role-name $IAM_COPY_TASK_ROLE  --policy-arn  $IAM_COPY_TASK_POLICY_ARN



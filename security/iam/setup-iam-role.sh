#!/bin/bash
# Script sets up a policy and an IAM user

# Check if the two required args were provided
if [ "$#" -ne 2 ]; then
    echo "Aborting !!  Usage: setup-iam-user  AWS_ACC_NUMBER   DB_RESOURCE_ID"
    exit
fi

# Sets the args in local vars
AWS_ACCOUNT=$1
DB_RESOURCE_ID=$2
AWSREGION=$AWS_DEFAULT_REGION

# If you change the names here then change in the other scripts as well
IAM_DBUSER_POLICY=rdsa-iam-dbuser-policy
IAM_DBUSER_ROLE=rdsa-iam-dbuser-role

# Create the IAM policy JSON
read -r -d '' JSON_POLICY << EOL
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Effect": "Allow",
         "Action": [
             "rds-db:connect"
         ],
         "Resource": [
             "arn:aws:rds-db:$AWSREGION:$AWS_ACCOUNT:dbuser:$DB_RESOURCE_ID/iam_dbuser"
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
aws iam create-policy --policy-name  $IAM_DBUSER_POLICY --policy-document "$JSON_POLICY" > /dev/null

# Get the policy ARN
IAM_DBUSER_POLICY_ARN=$(aws iam list-policies --query "Policies[?PolicyName=='$IAM_DBUSER_POLICY'].Arn" --output text)
echo "IAM_DBUSER_POLICY ARN=$IAM_DBUSER_POLICY_ARN"

# Create the role trust policy
# This trust policy will allow the Role used for Bastion host to assume the IAM DB Role
BASTION_HOST_ROLE=($(jq -r '.Arn' <<< $(aws sts get-caller-identity)))

read -r -d ''  ASSUME_ROLE_POLICY << EOL
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Principal": { "AWS": "$BASTION_HOST_ROLE" },
        "Action": "sts:AssumeRole"
    }
}
EOL

# Write out the trust policy to temp file
echo "$ASSUME_ROLE_POLICY" > /tmp/assume-policy.json


# Create the role with the trust policy
aws iam create-role --role-name $IAM_DBUSER_ROLE --assume-role-policy-document  file:///tmp/assume-policy.json
IAM_DBUSER_ROLE_ARN=$(aws iam list-roles --query "Roles[?RoleName=='$IAM_DBUSER_ROLE'].Arn" --output text)
echo "IAM_DBUSER_ROLE Arn=$IAM_DBUSER_ROLE_ARN"

# Attach the role to policy IAM_DBUSER_POLICY
echo "Attaching the DBUSER policy to DBUSER role"
aws iam attach-role-policy   --role-name $IAM_DBUSER_ROLE  --policy-arn  $IAM_DBUSER_POLICY_ARN



#!/bin/bash
# Script sets up a policy and an IAM user

if [$# -ne 2];
    echo "Aborting !!  Usage: setup-iam-user  AWS_ACC_NUMBER   DB_RESOURCE_ID"
    exit
fi

AWS_ACCOUNT=$1
DB_RESOURCE_ID=$2
AWSREGION=$AWS_DEFAULT_REGION

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

echo $JSON_POLICY

jq <<< '$JSON_POLICY'


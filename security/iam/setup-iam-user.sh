#!/bin/bash
# Script sets up a policy and an IAM user

$AWS_ACCOUNT=$1
DB_RESOURCE_ID=$2

read -r -r '' JSON_POLICY << EOL
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

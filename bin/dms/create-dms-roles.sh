#!/bin/bash
#These roles gets created automatically if you are using the DMS from console
#If you are using CLI then they need to be created


#Common trust policy for all roles
read -r -d ''  ASSUME_ROLE_POLICY << EOL 
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
            "Service": "dms.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOL
# Write out the trust policy to temp file
echo "$ASSUME_ROLE_POLICY" > /tmp/assume-policy.json

#------------------dms_vpc_role---------------
DMS_VPC_ROLE=dms-vpc-role
DMS_VPC_MANAGEMENT_ROLE=AmazonDMSVPCManagementRole

# Check if the role exist
DMS_VPC_ROLE_ARN=$(aws iam list-roles --query "Roles[?RoleName=='$DMS_VPC_ROLE'].Arn" --output text)

if  [ "$DMS_VPC_ROLE_ARN" == "" ]; then

# Create the role with the trust policy
aws iam create-role --role-name $DMS_VPC_ROLE --assume-role-policy-document  file:///tmp/assume-policy.json  > /dev/null
DMS_VPC_ROLE_ARN=$(aws iam list-roles --query "Roles[?RoleName=='$DMS_VPC_ROLE'].Arn" --output text)

echo "DMS_VPC_ROLE Arn=$DMS_VPC_ROLE_ARN"

# Attach the role to policy IAM_COPY_TASK_POLICY
echo "Attaching the IAM policy to IAM role"
aws iam attach-role-policy   --role-name $DMS_VPC_ROLE  --policy-arn arn:aws:iam::aws:policy/service-role/$DMS_VPC_MANAGEMENT_ROLE
echo "Created: $DMS_VPC_ROLE"
else
    echo "$DMS_VPC_ROLE role exists - no action taken !!"
fi

#-----------------------------------------------------------



# #---------------dms-cloudwatch-logs-role------------------
DMS_CW_ROLE=dms-cloudwatch-logs-role
DMS_CW_MANAGEMENT_ROLE=AmazonDMSCloudWatchLogsRole

# Check if the role exist
DMS_CW_ROLE_ARN=$(aws iam list-roles --query "Roles[?RoleName=='$DMS_CW_ROLE'].Arn" --output text)

if  [ "$DMS_CW_ROLE_ARN" == "" ]; then

# Create the role with the trust policy
aws iam create-role --role-name $DMS_CW_ROLE --assume-role-policy-document  file:///tmp/assume-policy.json  > /dev/null
DMS_CW_ROLE_ARN=$(aws iam list-roles --query "Roles[?RoleName=='$DMS_CW_ROLE'].Arn" --output text)

echo "DMS_CW_ROLE Arn=$DMS_CW_ROLE_ARN"

# Attach the role to policy IAM_COPY_TASK_POLICY
echo "Attaching the IAM policy to IAM role"
aws iam attach-role-policy   --role-name $DMS_CW_ROLE  --policy-arn arn:aws:iam::aws:policy/service-role/$DMS_CW_MANAGEMENT_ROLE
echo "Created: $DMS_CW_ROLE"
else
    echo "$DMS_CW_ROLE role exists - no action taken !!"
fi

# #-------------------------


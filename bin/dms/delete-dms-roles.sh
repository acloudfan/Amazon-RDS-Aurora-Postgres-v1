#!/bin/bash
#Deletes the roles for DMS


#----dms_vpc_role----
# Check if the role exist
DMS_VPC_ROLE=dms_vpc_role
DMS_VPC_ROLE_ARN=$(aws iam list-roles --query "Roles[?RoleName=='$DMS_VPC_ROLE'].Arn" --output text)
DMS_VPC_MANAGEMENT_ROLE=AmazonDMSVPCManagementRole

if  [ "$DMS_VPC_ROLE_ARN" == "" ]; then
    echo "Role Not Found - No action taken."
else 
    DMS_VPC_MANAGEMENT_ROLE_ARN=$(aws iam list-policies --query "Policies[?PolicyName=='$DMS_VPC_MANAGEMENT_ROLE'].Arn" --output text)
    echo "Detaching the  DMS_VPC_ROLE"
    aws iam detach-role-policy --role-name $DMS_VPC_ROLE --policy-arn $DMS_VPC_MANAGEMENT_ROLE_ARN
    echo "Deleting the $DMS_VPC_ROLE"
    aws iam delete-role --role-name $DMS_VPC_ROLE
    echo "Done."
fi


#----dms_vpc_role----
# Check if the role exist
DMS_CW_ROLE=dms-cloudwatch-logs-role
DMS_CW_MANAGEMENT_ROLE=AmazonDMSCloudWatchLogsRole

DMS_CW_ROLE_ARN=$(aws iam list-roles --query "Roles[?RoleName=='$DMS_VPC_ROLE'].Arn" --output text)


if  [ "$DMS_CW_ROLE_ARN" == "" ]; then
    echo "Role Not Found - No action taken."
else 
    DMS_CW_MANAGEMENT_ROLE_ARN=$(aws iam list-policies --query "Policies[?PolicyName=='$DMS_CW_MANAGEMENT_ROLE'].Arn" --output text)
    echo "Detaching the  DMS_VPC_ROLE"
    aws iam detach-role-policy --role-name $DMS_CW_ROLE --policy-arn $DMS_CW_MANAGEMENT_ROLE_ARN
    echo "Deleting the $DMS_CW_ROLE"
    aws iam delete-role --role-name $DMS_CW_ROLE
    echo "Done."
fi
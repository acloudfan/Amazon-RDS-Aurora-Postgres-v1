#!/bin/bash
#Deletes the roles for DMS


#----dms_vpc_role----
# Check if the role exist
DMS_VPC_ROLE=dms-vpc-role
DMS_VPC_ROLE_ARN=$(aws iam list-roles --query "Roles[?RoleName=='$DMS_VPC_ROLE'].Arn" --output text)
DMS_VPC_MANAGEMENT_ROLE=AmazonDMSVPCManagementRole

if  [ "$DMS_VPC_ROLE_ARN" == "" ]; then
    echo "Role $DMS_VPC_ROLE Not Found - No action taken."
else 
    # DMS_VPC_MANAGEMENT_ROLE_ARN=$(aws iam list-policies --query "Policies[?PolicyName=='$DMS_VPC_MANAGEMENT_ROLE'].Arn" --output text)
    echo "Detaching the  $DMS_VPC_MANAGEMENT_ROLE"
    # aws iam detach-role-policy --role-name $DMS_VPC_ROLE --policy-arn $DMS_VPC_MANAGEMENT_ROLE_ARN
    aws iam detach-role-policy --role-name $DMS_VPC_ROLE --policy-arn arn:aws:iam::aws:policy/service-role/$DMS_VPC_MANAGEMENT_ROLE
    echo "Deleting the $DMS_VPC_ROLE"
    aws iam delete-role --role-name $DMS_VPC_ROLE
    echo "Done."
fi


#----dms-cloudwatch-logs-role----
# Check if the role exist
DMS_CW_ROLE=dms-cloudwatch-logs-role
DMS_CW_MANAGEMENT_ROLE=AmazonDMSCloudWatchLogsRole

DMS_CW_ROLE_ARN=$(aws iam list-roles --query "Roles[?RoleName=='$DMS_CW_ROLE'].Arn" --output text)


if  [ "$DMS_CW_ROLE_ARN" == "" ]; then
    echo "Role $DMS_CW_ROLE Not Found - No action taken."
else 
    DMS_CW_MANAGEMENT_ROLE_ARN=$(aws iam list-policies --query "Policies[?PolicyName=='$DMS_CW_MANAGEMENT_ROLE'].Arn" --output text)
    echo "Detaching the  DMS_VPC_ROLE"
    aws iam detach-role-policy --role-name $DMS_CW_ROLE --policy-arn $DMS_CW_MANAGEMENT_ROLE_ARN
    echo "Deleting the $DMS_CW_MANAGEMENT_ROLE"
    aws iam delete-role --role-name $DMS_CW_ROLE
    echo "Done."
fi



# -------

DMS_S3_ROLE=rdsa-dms-s3-role
DMS_S3_FULL_ACCESS=AmazonS3FullAccess

DMS_S3_ROLE_ARN=$(aws iam list-roles --query "Roles[?RoleName=='$DMS_S3_ROLE'].Arn" --output text)
if  [ "$DMS_S3_ROLE_ARN" == "" ]; then
    echo "Role $DMS_S3_ROLE Not Found - No action taken."
else 
    DMS_S3_FULL_ACCESS_ARN=$(aws iam list-policies --query "Policies[?PolicyName=='$DMS_S3_FULL_ACCESS'].Arn" --output text)
    echo "Detaching the  DMS_VPC_ROLE"
    aws iam detach-role-policy --role-name $DMS_S3_FULL_ACCESS --policy-arn $DMS_S3_FULL_ACCESS_ARN
    echo "Deleting the $DMS_S3_ROLE"
    aws iam delete-role --role-name $DMS_S3_ROLE
    echo "Done."
fi
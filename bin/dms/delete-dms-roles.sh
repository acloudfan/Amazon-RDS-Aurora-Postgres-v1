#!/bin/bash
#Deletes the roles for DMS

# Check if the role exist
DMS_VPC_ROLE=dms_vpc_role
DMS_VPC_ROLE_ARN=$(aws iam list-roles --query "Roles[?RoleName=='$DMS_VPC_ROLE'].Arn" --output text)

if  [ "$DMS_VPC_ROLE_ARN" == "" ]; then
    echo "Role Not Found - No action taken."
else 
    aws iam delete-role --role-name $DMS_VPC_ROLE
    echo "Done."
fi
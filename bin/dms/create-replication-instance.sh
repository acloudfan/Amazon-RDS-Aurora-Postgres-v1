#!/bin/bash
#Creates the Replication instance
# https://docs.aws.amazon.com/cli/latest/reference/dms/create-replication-instance.html



# Subnet group
REPL_SUBNET_GROUP_ID=rdsa-dms-subnet-group
REPL_INSTANCE_IDENTIFIER=rdsa-dms-replication-instance

INSTANCE_IDENTIFIER=rdsa-dms-replication-instance

# NOT ALL instances supported for all engine versions - check documentation
INSTANCE_CLASS=dms.t3.medium
INSTANCE_ENGINE_VERSION=3.4.6

#[--multi-az | --no-multi-az]
INSTANCE_MULTI_AZ=--no-multi-az
#[--publicly-accessible | --no-publicly-accessible]
INSTANCE_PUBLIC_ACCESS=--no-publicly-accessible
INSTANCE_ALLOCATED_STORE=5

aws dms create-replication-instance \
    --replication-instance-identifier  $REPL_INSTANCE_IDENTIFIER \
    --replication-instance-class  $INSTANCE_CLASS  \
    --allocated-storage  $INSTANCE_ALLOCATED_STORE \
    --engine-version   $INSTANCE_ENGINE_VERSION   \
    --replication-subnet-group-identifier  $REPL_SUBNET_GROUP_ID \
    $INSTANCE_MULTI_AZ \
    $INSTANCE_PUBLIC_ACCESS  

if  [ $? == 0 ]; then
    echo 'Creation will take a couple of minutes .. '
    echo 'Done.'
else
    echo 'Make sure to create the Replication-Subnet-Group.'
    echo 'Failed !!!'
fi





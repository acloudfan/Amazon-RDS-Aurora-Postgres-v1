#!/bin/bash
#Creates the Replication instance
# https://docs.aws.amazon.com/cli/latest/reference/dms/create-replication-task.html
#
# Usage "./bin/dms/create-replication-task.sh <PATH-to-task-setting-JSON> <PATH-to-taks-mapping-JSON>"

if [ -z "$1" ]; then
    echo "Usage:  ./bin/dms/create-replication-task.sh  <PATH-to-task-setting-JSON>  <PATH-to-task-mapping-JSON> "
    echo "Please provide path to task setting JSON !!"
    exit
else
    TASK_SETTING=$(cat $1)
    TASK_SETTING_FILE=$1
    echo "Task settings: $TASK_SETTING_FILE"
fi

if [ -z "$2" ]; then
    echo "Usage:  ./bin/dms/create-replication-task.sh   <PATH-to-task-setting-JSON> <PATH-to-task-mapping-JSON>"
    echo "Please provide path to task mapping JSON !!"
    exit
else
    TABLE_MAPPING=$(cat $2)
    TABLE_MAPPING_FILE=$2
    echo "Table mappings: $TABLE_MAPPING_FILE"
fi

REPL_TASK_IDENTIFIER=rdsa-mysql-to-postgresql

REPL_INSTANCE_IDENTIFIER=rdsa-dms-replication-instance
SOURCE_ENDPOINT_IDENTIFIER=mysql-on-bastion-host
TARGET_ENDPOINT_IDENTIFIER=rdsa-postgresql-cluster
# [full-load | cdc | full-load-and-cdc]
MIGRATION_TYPE=full-load-and-cdc
# https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TableMapping.html



# Get the ARN for instance
REPL_INSTANCE_ARN=$(aws dms describe-replication-instances  \
    --output  text \
    --query  "ReplicationInstances[?ReplicationInstanceIdentifier=='${REPL_INSTANCE_IDENTIFIER}'].ReplicationInstanceArn | [0]")

# Check if ARN valid
if  [ "$REPL_INSTANCE_ARN" == "" ]; then
    echo "Replication instance not created !!"
    echo "Aborting."
    exit
else
    echo "Replication Instance ARN = $REPL_INSTANCE_ARN"
fi

# Get the ARN for source EP
SOURCE_ENDPOINT_ARN=$(aws dms  describe-endpoints \
    --output text  \
    --query  "Endpoints[?EndpointIdentifier=='${SOURCE_ENDPOINT_IDENTIFIER}'].EndpointArn | [0]")

# Check if ARN valid
if  [ "$SOURCE_ENDPOINT_ARN" == "" ]; then
    echo "Source EP not created !!"
    echo "Aborting."
    exit
else
    echo "Source Endpoint ARN = $SOURCE_ENDPOINT_ARN"
fi


# Get the ARN for the target EP
TARGET_ENDPOINT_ARN=$(aws dms  describe-endpoints \
    --output text  \
    --query  "Endpoints[?EndpointIdentifier=='${TARGET_ENDPOINT_IDENTIFIER}'].EndpointArn | [0]")

# Check if ARN valid
if  [ "$TARGET_ENDPOINT_ARN" == "" ]; then
    echo "Target EP not created !!"
    echo "Aborting."
    exit
else
    echo "Target Endpoint ARN = $TARGET_ENDPOINT_ARN"
fi


# Create the Replication task
aws dms create-replication-task  \
    --replication-task-identifier   $REPL_TASK_IDENTIFIER \
    --replication-instance-arn $REPL_INSTANCE_ARN \
    --source-endpoint-arn  $SOURCE_ENDPOINT_ARN  \
    --target-endpoint-arn  $TARGET_ENDPOINT_ARN \
    --migration-type $MIGRATION_TYPE \
    --replication-task-settings   "$TASK_SETTING_FILE" \
    --table-mappings "$TABLE_MAPPING_FILE"

if  [ $? == 0 ]; then
    echo 'Creation of task will take < a minute .. '
    echo 'Done.'
else
    echo 'Failed !!!'
fi
#!/bin/bash
# Creates a Named Replica
# Usage: ./bin/db/create-replica.sh  <<node name>>
#        ./bin/db/create-replica.sh  node-02

if [ -z "$1" ]; then
    echo "Usage: ./bin/db/create-replica.sh  <<node name>>  [Instance type   db.t3.medium=default] [Engine version  13.4=default]"
    echo "       ./bin/db/create-replica.sh  node-02"
    exit
fi

SLEEP_TIME=10s
RDSA_CLUSTER_CF_STACK_NAME="rdsa-postgresql"
RDSA_REPLICA_CF_STACK_NAME="rdsa-postgresql-$1"

TEMPLATE_LOCATION=file:///home/ec2-user/cloudformation/postgres-cluster-replica.yml \

# CF Parameters
RDSA_DB_CLUSTER_ID="rdsa-postgresql-cluster"
DB_INSTANCE_TYPE="db.t3.medium"
if [ -z "$2" ]; then
    echo "DB Instance Type=$DB_INSTANCE_TYPE"
else
    DB_INSTANCE_TYPE="$2"
    echo "DB Instance Type=$DB_INSTANCE_TYPE"
fi

DB_ENGINE_VERSION="13.4"
if [ -z "$2" ]; then
    echo "DB Engine Version=$DB_ENGINE_VERSION"
else
    DB_ENGINE_VERSION="$3"
    echo "DB Instance Type=$DB_ENGINE_VERSION"
fi

# Create the stack
aws cloudformation create-stack \
--stack-name "$RDSA_REPLICA_CF_STACK_NAME" --template-body "$TEMPLATE_LOCATION"  \
--parameters ParameterKey=TemplateName,ParameterValue="$RDSA_CLUSTER_CF_STACK_NAME"  \
ParameterKey=DBInstanceClass,ParameterValue="$DB_INSTANCE_TYPE"  \
ParameterKey=DBEngineVersion,ParameterValue="$DB_ENGINE_VERSION"  \
ParameterKey=DBCluster,ParameterValue="$RDSA_DB_CLUSTER_ID"  

# Wait for the stack to be created
while [ $? == 0 ]; do
    sleep $SLEEP_TIME
    CF_STACK_STATUS=$(aws  cloudformation describe-stacks --stack-name $RDSA_REPLICA_CF_STACK_NAME --output text --query 'Stacks[0].StackStatus')
    if [[ $CF_STACK_STATUS == "CREATE_IN_PROGRESS" ]]; then
        echo -n "."
    else
        break
    fi
done;
echo "."
echo "Done."

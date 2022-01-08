#!/bin/bash
#Modifies the instance type in the DB Cluster
# Usage: ./bin/bash/db    INSTANCE_NAME  INSTANCE_CLASS  [--apply-immediately=default | --no-apply-immediately]

if [ -z "$1" ]; then
    echo "Missing INSTANCE_NAME"
    echo " Usage: ./bin/bash/db    INSTANCE_NAME  INSTANCE_CLASS  [--apply-immediately=default | --no-apply-immediately]"
    exit
else
    INSTANCE_NAME=$1
fi

if [ -z "$2" ]; then
    echo "Missing INSTANCE_CLASS"
    echo " Usage: ./bin/bash/db    INSTANCE_NAME  INSTANCE_CLASS  [--apply-immediately=default | --no-apply-immediately]"
    exit
else
    INSTANCE_CLASS=$2
fi

APPLY_IMMEDIATELY=--apply-immediately

if [ "$3" != "" ]; then
    APPLY_IMMEDIATELY=$3
fi


aws rds modify-db-instance \
    --db-instance-identifier $INSTANCE_NAME \
    --db-instance-class $INSTANCE_CLASS \
    $APPLY_IMMEDIATELY
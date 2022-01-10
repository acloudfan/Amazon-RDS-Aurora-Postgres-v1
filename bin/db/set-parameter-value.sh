#!/bin/bash
#Sets the value of the parameters - applies immediately
#Usage: ./bin/db/set-parameter-value  <PG Name> <Parameter Name> <Parameter Value>

if [ -z "$1" ]; then
    echo "Usage: ./bin/db/set-parameter-value  <PG Name> <Parameter Name> <Parameter Value>"
    echo "Please provide the Name !!"
    exit
fi

if [ -z "$2" ]; then
    echo "Usage: ./bin/db/set-parameter-value  <PG Name> <Parameter Name> <Parameter Value>"
    echo "Please provide the Parameter Name !!"
    exit
fi

if [ -z "$3" ]; then
    echo "Usage: ./bin/db/set-parameter-value  <PG Name> <Parameter Name> <Parameter Value>"
    echo "Please provide the Parameter Value !!"
    exit
fi

DBPG_NAME=$1
PARAM_NAME=$2
PARAM_VALUE=$3

echo "Setting in DB Parameter Group: $DBPG_NAME"
echo "                        $PARAM_NAME=$PARAM_VALUE"

aws rds modify-db-cluster-parameter-group \
    --db-cluster-parameter-group-name $DBPG_NAME \
    --parameters "ParameterName=$PARAM_NAME,ParameterValue=$PARAM_VALUE,ApplyMethod=immediate" 

echo "Done."
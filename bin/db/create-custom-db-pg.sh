#!/bin/bash
#Script creates the DB parameter group for the given DB family
#https://docs.aws.amazon.com/cli/latest/reference/rds/create-db-parameter-group.html
# Usage:  ./bin/bash/create-custom-db-pg.sh  <Name>  '<Description>'

if [ -z "$1" ]; then
    echo "Usage:  ./bin/bash/create-custom-db-pg.sh  <Name>  '<Description>'"
    echo "Please provide the Name !!"
    exit
fi

if [ -z "$2" ]; then
    echo "Usage:  ./bin/bash/create-custom-db-pg.sh  <Name>  '<Description>'"
    echo "Please provide the Description !!"
    exit
fi

DBPG_NAME=$1
DBPG_DESC=$2

# Get th emajor version
PG_VERSION=$(psql -t -c "SHOW server_version" )
PG_VERSION=$(echo $PG_VERSION | cut -d'.' -f 1)

# Get the Engine name for the cluster
PG_ENGINE=$(aws rds  describe-db-clusters --output text \
 --db-cluster-identifier $PG_CLUSTER_ID  \
 --query  "DBClusters[0].Engine") 

# Create the engine family
PG_ENGINE="$PG_ENGINE""$PG_VERSION"

# Use CLI to create the DB Parameter Group
echo "Create the DB Parameter Group: $DBPG_NAME"
echo "                       Family: $PG_ENGINE"

aws rds create-db-cluster-parameter-group   \
    --db-cluster-parameter-group-name       "$DBPG_NAME"  \
    --db-parameter-group-family     "$PG_ENGINE"  \
    --description                   "$DBPG_DESC"


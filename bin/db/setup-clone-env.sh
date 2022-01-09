#!/bin/bash
# Update the ~/.bashrc 
# Sets up the environment variables for connecting with the clone
# Usage : source   ./bin/db/setup-clone-env.sh   [PG_CLUSTER_ID=rdsa-postgresql-clone-cluster]
# MUST be used with 'source'

export PG_CLUSTER_ID=rdsa-postgresql-clone-cluster

if [ -z "$1" ]; then
    echo "Using PG_CLUSTER_ID=$PG_CLUSTER_ID"
else
  PG_CLUSTER_ID="$1"
  echo "Using PG_CLUSTER_ID=$PG_CLUSTER_ID"
fi

echo "Region = $AWS_DEFAULT_REGION"

export PGWRITEREP="$(aws rds describe-db-clusters  --db-cluster-identifier $PG_CLUSTER_ID | jq -r .DBClusters[0].Endpoint)"

export PGREADEREP=$(aws rds describe-db-clusters  --db-cluster-identifier $PG_CLUSTER_ID | jq -r .DBClusters[0].ReaderEndpoint)

export PGHOST=$PGWRITEREP

export PGPORT=5432

export PGUSER=masteruser

export PGPASSWORD=masteruserpw

export PGDATABASE=labdb

env | grep PG
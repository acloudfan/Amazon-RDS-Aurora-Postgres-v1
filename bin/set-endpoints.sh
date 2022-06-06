#!/bin/bash
# Utility sets up the environment variables for the Cluster & Reader endpoints
# The setup applies only to the session 
# Usage:  source   ./bin/set-endpoints.sh   <RDS Cluster Identifier>

if [ -z "$1" ]; then
    echo "Usage: source ./bin/set-endpoints.sh  <RDS Cluster Identifier> "
    echo "e.g.,   ./bin/set-endpoints.sh  my-cluster"
    exit 
fi

PG_CLUSTER_ID=$1

export PGWRITEREP="$(aws rds describe-db-clusters  --db-cluster-identifier $PG_CLUSTER_ID | jq -r .DBClusters[0].Endpoint)"
export PGHOST=$PGWRITEREP
export PGREADEREP=$(aws rds describe-db-clusters  --db-cluster-identifier $PG_CLUSTER_ID | jq -r .DBClusters[0].ReaderEndpoint)

echo "PGWRITEREP=$PGWRITEREP"
echo "PGREADEREP=$PGREADEREP"


#!/bin/bash

export PGWRITEREP="$(aws rds describe-db-clusters --region us-east-1 --db-cluster-identifier rdsa-postgresql-cluster | jq -r .DBClusters[0].Endpoint)"

export PGREADEREP=$(aws rds describe-db-clusters --region us-east-1 --db-cluster-identifier rdsa-postgresql-cluster | jq -r .DBClusters[0].ReaderEndpoint)

export PGHOST=$PGWRITEREP

export PGPORT=5432
export PGUSER=masteruser
export PGPASSWORD=masteruserpw
export PGDATABASE=labdb
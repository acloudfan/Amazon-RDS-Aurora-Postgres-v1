#!/bin/bash
# Usage: dbluster [default = status | start | stop]

ACTION=$1
DB_CLUSTER_ID="rdsa-postgresql-cluster"

# By deault script will print the cluster status
if [ -z "$1" ]; then
    ACTION="status"
elif [[ "stop" == "$ACTION" ]]; then
     echo  "REMEMBER : RDS Database clusters start automatically after 7 days !!!"
fi

if [[ "status" == "$ACTION" ]]; then
     STATUS=$(aws rds describe-db-clusters  --db-cluster-identifier "$DB_CLUSTER_ID"   --query 'DBClusters[0].Status')
     echo "DB Cluster [$DB_CLUSTER_ID]: $STATUS"
elif [[ "$ACTION" == "stop" ]]; then
     aws rds stop-db-cluster --db-cluster-identifier $DB_CLUSTER_ID
     STATUS=$(aws rds describe-db-clusters  --db-cluster-identifier "$DB_CLUSTER_ID"   --query 'DBClusters[0].Status')
     echo "DB Cluster [$DB_CLUSTER_ID]: $STATUS"
elif [[ "$ACTION" == "start" ]]; then
     aws rds start-db-cluster --db-cluster-identifier $DB_CLUSTER_ID
     STATUS=$(aws rds describe-db-clusters  --db-cluster-identifier "$DB_CLUSTER_ID"   --query 'DBClusters[0].Status')
     echo "DB Cluster [$DB_CLUSTER_ID]: $STATUS"
else
    echo "Usage: dbluster [default = status | start | stop]"
fi

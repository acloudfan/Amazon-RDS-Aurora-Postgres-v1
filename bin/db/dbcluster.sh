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
     CHECK=$(aws rds stop-db-cluster --db-cluster-identifier $DB_CLUSTER_ID)
     if [ $? <> 0 ]; then
          echo "FAILED to stop .. Check error message !!!"
          exit
     fi
     STATUS=$(aws rds describe-db-clusters  --db-cluster-identifier "$DB_CLUSTER_ID"   --query 'DBClusters[0].Status')
     echo "Attempting to STOP the cluster...if script ends, just run it again"
     # Continuously check the starting status
     while [ $? == 0 ]; do
          sleep 10
          STATUS=$(aws  rds describe-db-clusters  --db-cluster-identifier "$DB_CLUSTER_ID"   --output text --query 'DBClusters[0].Status')
          if [[ "$STATUS" == "stopping" ]]; then
               echo -n "."
          else
               break
          fi
     done;
     echo "."
     echo "Status: $STATUS"
elif [[ "$ACTION" == "start" ]]; then
     CHECK=$(aws rds start-db-cluster --db-cluster-identifier $DB_CLUSTER_ID)
     STATUS=$(aws rds describe-db-clusters  --db-cluster-identifier "$DB_CLUSTER_ID"   --query 'DBClusters[0].Status')
     echo "Attempting to START the cluster...if script ends, just run it again!!!"

     # Continuously check the starting status
     while [ $? == 0 ]; do
          sleep 10
          STATUS=$(aws  rds describe-db-clusters  --db-cluster-identifier "$DB_CLUSTER_ID"   --output text --query 'DBClusters[0].Status')
          if [[ "$STATUS" == "starting" ]]; then
               echo -n "."
          else
               break
          fi
     done;
     echo "."
     echo "Status: $STATUS"

else
    echo "Usage: dbluster [status (default) | start | stop]"
fi

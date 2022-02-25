#!/bin/bash
#Deletes the specified cluster
# Usage: ./bin/db/delete-replica.sh  <<node name>>
#        ./bin/db/delete-replica.sh  node-02

if [ -z "$1" ]; then
    echo "Usage: ./bin/db/create-replica.sh  <<node name>>  [Instance type   db.t3.medium=default] [Engine version  13.4=default]"
    echo "       ./bin/db/create-replica.sh  node-02"
    exit
fi

SLEEP_TIME=5s
RDSA_REPLICA_CF_STACK_NAME="rdsa-postgresql-$1"

# Confirm from user
while true; do
    read -p "Are you sure, you want to DELETE the replica stack [$RDSA_REPLICA_CF_STACK_NAME] ?" yn
    case $yn in
        [Nn]* ) exit;;
        [Yy]* ) break;;
        * ) echo "Please answer yes/y or no/n.";;
    esac
done

echo "Be aware that sometimes, the stack deletion fails !!"
echo "NOTE: It is your responsibility to ensure that the DB node is successfully deleted."


# Delete the stack
aws cloudformation delete-stack --stack-name "$RDSA_REPLICA_CF_STACK_NAME"

# Continuously check the delete status
while [ $? == 0 ]; do
    sleep $SLEEP_TIME
    STATUS=$(aws  cloudformation describe-stacks --output text --stack-name "$RDSA_REPLICA_CF_STACK_NAME" --query 'Stacks[0].StackStatus')
    if [[ "$STATUS" == "DELETE_IN_PROGRESS" ]]; then
        echo -n "."
    elif [[ "$STATUS" == "DELETE_FAILED" ]]; then
        echo "Delete FAILED!!"
        echo "This generally happens if the DB Cluster is in STOPPED State."
        echo "Please START DB cluster & try again. To start use : ./bin/db/dbcluster.sh start"
        break
    else
        break
    fi
done;
echo "."

echo "Done."
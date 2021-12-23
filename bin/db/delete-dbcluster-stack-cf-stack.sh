#!/bin/bash
# This scripts deletes an existing CloudFormation stack
# If there is a DRIFT then CF may fail to delete the cluster

RDSA_CLUSTER_CF_STACK_NAME="rdsa-postgresql"

# Confirm from user
while true; do
    read -p "Are you sure, you want to DELETE the Aurora clust [$RDSA_CLUSTER_CF_STACK_NAME] ?" yn
    case $yn in
        [Nn]* ) exit;;
        [Yy]* ) break;;
        * ) echo "Please answer yes/y or no/n.";;
    esac
done

echo "Be aware that sometimes, the stack deletion fails !!"
echo "NOTE: It is your responsibility to ensure that the cluster is successfully deleted."

# Delete the stack
aws cloudformation delete-stack --stack-name "$RDSA_CLUSTER_CF_STACK_NAME"

# Continuously check the delete status
while [ $? == 0 ]; do
    SLEEP 5
    STATUS=$(aws  cloudformation describe-stacks --stack-name rdsa-postgresql --query 'Stacks[0].StackStaus')
    if [ $STATUS == "DELETE_IN_PROGRESS" ]]; then
        echo -n "."
    else
        break
    fi
done;

echo "Done."
#!/bin/bash
#Deletes the subnet group
#https://docs.aws.amazon.com/cli/latest/reference/dms/delete-replication-subnet-group.html


REPL_SUBNET_GROUP_ID=rdsa-dms-subnet-group

aws dms delete-replication-subnet-group  \
    --replication-subnet-group-identifier   $REPL_SUBNET_GROUP_ID

echo "Done."
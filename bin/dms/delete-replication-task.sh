#!/bin/bash
#Deletes the replication task

REPL_TASK_IDENTIFIER=rdsa-mysql-to-postgresql

REPL_TASK_ARN=$(aws dms describe-replication-tasks \
    --output text  \
    --query  "ReplicationTasks[?ReplicationTaskIdentifier=='${REPL_TASK_IDENTIFIER}'].ReplicationTaskArn | [0]")

aws dms delete-replication-task \
    --replication-task-arn   $REPL_TASK_ARN

echo "Deleting Replication Task: $REPL_TASK_IDENTIFIER"
echo "Deletion may take a few minutes...check status on DMS console"
echo "Done."
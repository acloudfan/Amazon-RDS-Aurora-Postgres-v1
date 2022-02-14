#!/bin/bash
#Stops & Deletes the replication task

REPL_TASK_IDENTIFIER=rdsa-mysql-to-postgresql
SLEEP_WAIT=5s

REPL_TASK_ARN=$(aws dms describe-replication-tasks \
    --output text  \
    --query  "ReplicationTasks[?ReplicationTaskIdentifier=='${REPL_TASK_IDENTIFIER}'].ReplicationTaskArn | [0]")

# Stop the replication task
# https://docs.aws.amazon.com/cli/latest/reference/dms/stop-replication-task.html
aws dms stop-replication-task --replication-task-arn $REPL_TASK_ARN

sleep  SLEEP_WAIT

# Delete the replication task
aws dms delete-replication-task \
    --replication-task-arn   $REPL_TASK_ARN

echo "Deleting Replication Task: $REPL_TASK_IDENTIFIER"
echo "Deletion may take a few minutes...check status on DMS console"
echo "Done."
#!/bin/bash
#Stops & Deletes the replication task

REPL_TASK_IDENTIFIER=rdsa-mysql-to-postgresql
SLEEP_WAIT=3s

REPL_TASK_ARN=$(aws dms describe-replication-tasks \
    --output text  \
    --query  "ReplicationTasks[?ReplicationTaskIdentifier=='${REPL_TASK_IDENTIFIER}'].ReplicationTaskArn | [0]")

echo $REPL_TASK_ARN
#Check if the ARN is valid
if  [ "$REPL_TASK_ARN" == "None" ]; then
    echo "Replication task not created !!"
    echo "Aborting."
    exit
fi


# Stop the replication task
# https://docs.aws.amazon.com/cli/latest/reference/dms/stop-replication-task.html
STATUS=$(aws  dms describe-replication-tasks  --output text --query "ReplicationTasks[?ReplicationTaskIdentifier=='${REPL_TASK_IDENTIFIER}'].Status | [0]")
if [[ "$STATUS" == "stopped" ]]; then
    echo "Task already STOPPED"
else
    aws dms stop-replication-task --replication-task-arn $REPL_TASK_ARN
fi



echo "Attempting to stop: $REPL_TASK_ARN"
# Continuously check the  status
while [ $? == 0 ]; do
    sleep $SLEEP_WAIT
    STATUS=$(aws  dms describe-replication-tasks  --output text --query "ReplicationTasks[?ReplicationTaskIdentifier=='${REPL_TASK_IDENTIFIER}'].Status | [0]")
    if [[ "$STATUS" == "stopped" ]]; then
        break
    else
        echo -n "."
    fi
done;


# Delete the replication task
aws dms delete-replication-task \
    --replication-task-arn   $REPL_TASK_ARN   > /dev/null

echo "Deleting Replication Task: $REPL_TASK_IDENTIFIER"
echo "Deletion may take a few minutes...check status on DMS console"
echo "Done."
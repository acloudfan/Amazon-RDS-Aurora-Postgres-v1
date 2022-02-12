#!/bin/bash
#Delete the replication instance
# https://docs.aws.amazon.com/cli/latest/reference/dms/delete-replication-instance.html
# https://docs.aws.amazon.com/cli/latest/reference/dms/describe-replication-instances.html

REPL_INSTANCE_IDENTIFIER=rdsa-dms-replication-instance

# Get ARN of the instance
REPL_INSTANCE_ARN=$(aws dms describe-replication-instances  \
    --output  text \
    --query  "ReplicationInstances[?ReplicationInstanceIdentifier=='${REPL_INSTANCE_IDENTIFIER}'].ReplicationInstanceArn | [0]")

echo  "Deleting Replication Instance with ARN = $REPL_INSTANCE_ARN"

aws dms delete-replication-instance \
    --replication-instance-arn    $REPL_INSTANCE_ARN

if  [ $? == 0 ]; then
    echo 'Deletion will take a couple of minutes ..  '
    echo 'NOTE: It is your responsibility to confirm deletion'
    echo '      Running instance may cost you $$$'
    echo 'Done.'
else
    echo 'Failed !!!'
fi
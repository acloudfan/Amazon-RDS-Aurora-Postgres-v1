#!/bin/bash
#BEWARE: This will delete the bastion host

CF_HOST_STACK=rdsa-bastion-host

if [ -z "$1" ]; then
    echo "Usage: ./bin/host/delete-host.sh  [linux=default |  windows] "
elif [[ "windows"=="$1" ]]; then
    CF_HOST_STACK="rdsa-bastion-host-windows"
else
    echo "Usage: ./bin/host/delete-host.sh  [linux=default |  windows] "
    echo "       Please specify linux or windows."
    exit
fi

# Confirm from user
while true; do
    read -p "Are you sure, you want to DELETE this CF stack []?" yn
    case $yn in
        [Nn]* ) exit;;
        [Yy]* ) break;;
        * ) echo "Please answer yes/y or no/n.";;
    esac
done

# Check if the stack  exists
HOST_STACK_STATUS=$(aws cloudformation  describe-stacks --stack-name $CF_HOST_STACK --query 'Stacks[0].StackStatus')
if [ $? != 0 ]; then
   echo "Stack [$HOST_STACK_STATUS] does not exist!!"
   echo "Aborting."
   exit
fi

# delete the stack
aws cloudformation delete-stack --stack-name "$CF_HOST_STACK"

while [ $? == 0 ]; do
    sleep 5
    STATUS=$(aws  cloudformation describe-stacks --output text --stack-name "$CF_HOST_STACK" --query 'Stacks[0].StackStatus')
    if [[ "$STATUS" == "DELETE_IN_PROGRESS" ]]; then
        echo -n "."
    else
        break
    fi
done;
echo "."

echo "Done."

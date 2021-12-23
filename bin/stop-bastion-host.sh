#!/bin/bash
# BEWARE: This script will stop the bastion host

# Confirm from user
while true; do
    read -p "Are you sure, you want to STOP this Host?" yn
    case $yn in
        [Nn]* ) exit;;
        * ) echo "Please answer yes/y or no/n.";;
    esac
done

# Get the instance ID
INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)

# Stop this bastion host EC2 instance
aws ec2 stop-instances --instance-ids $INSTANCE_ID


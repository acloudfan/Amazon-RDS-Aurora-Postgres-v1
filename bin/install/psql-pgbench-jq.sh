#!/bin/bash


if [ -z $SUDO_USER ]; then
    echo "Script MUST be executed with 'sudo'"
    echo "Aborting!!!"
    exit 0
fi


echo "Installing the postgresql11 tools"
amazon-linux-extras install postgresql11 vim epel -y

echo "Install the pgbench"
yum install postgresql-contrib -y

echo "Install jq"
sudo yum install -y jq


echo "Done"

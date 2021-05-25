#!/bin/bash

echo "Installing the postgresql11 tools"
amazon-linux-extras install postgresql11 vim epel -y

echo "Install pgbench tool"
yum install postgresql-contrib -y

echo "Install jq"
sudo yum install -y jq


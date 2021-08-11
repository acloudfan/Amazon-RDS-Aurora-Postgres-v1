#!/bin/bash
# Script installs the needed utilities, scripts & setsup the env !!

# install git
sudo yum update -y
sudo yum install git -y

# Clone the repository folder
cd ~
git clone https://github.com/acloudfan/Amazon-RDS-Aurora-Postgres-v1.git

# Install the tools
cp -r Amazon-RDS-Aurora-Postgres-v1/bin .
chmod -R u+x bin
sudo ./bin/install/psql-pgbench-jq.sh

# Setup the environment
if [ -z "$1" ]; then
    PG_CLUSTER_ID="$1"
fi

source ./bin/setup-env.sh



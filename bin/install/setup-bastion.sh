#!/bin/bash
# Script installs the needed utilities, scripts & setsup the env !!
#
# To setup env against a specific DB cluster, provide the $1=cluster id
# That would set the PG_CLUSTER_ID & invoke the ./bin/setup-env.sh

# Setup the environment
if [ -z "$1" ]; then
    echo "Must set default region"
    echo "Usage ./setup-bastion.sh  <<AWS Region>>  "
    exit 1
else
    export AWS_DEFAULT_REGION="$1"
fi


if [ -z "$2" ]; then
    # echo "Will use the default cluster ID !!"
    export PG_CLUSTER_ID=rdsa-postgresql-cluster
else
    export PG_CLUSTER_ID="$2"
fi


echo "Setting  AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION"
# echo "Setting  PG_CLUSTER_ID=$PG_CLUSTER_ID"


# install git
sudo yum update -y
sudo yum install git -y

# Clone the repository folder
cd ~
if [ -d "./Amazon-RDS-Aurora-Postgres-v1" ]; then rm -Rf ./Amazon-RDS-Aurora-Postgres-v1; fi
if [ -d "./cloudformation" ]; then rm -Rf ./cloudformation; fi

git clone https://github.com/acloudfan/Amazon-RDS-Aurora-Postgres-v1.git

# Copy the cloudformation templates
mkdir cloudformation
cp -r Amazon-RDS-Aurora-Postgres-v1/vpc/*.yml ./cloudformation
cp -r Amazon-RDS-Aurora-Postgres-v1/cluster-basic/*.yml ./cloudformation
cp -r Amazon-RDS-Aurora-Postgres-v1/replicas/*.yml ./cloudformation

# Install the tools
cp -r Amazon-RDS-Aurora-Postgres-v1/bin .
chmod -R u+x bin
sudo ./bin/install/psql-pgbench-jq.sh



# Setup the environment
# if [ -z "$1" ]; then
#      export PG_CLUSTER_ID="$1"
# fi

# Setup the environment variables in the ~/.bashrc
source ./bin/setup-env.sh



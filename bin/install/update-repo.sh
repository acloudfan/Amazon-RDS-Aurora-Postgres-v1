#!/bin/bash
#Updates the bastion host setup with latest repo objects

# Clone the repository folder
cd ~
if [ -d "./Amazon-RDS-Aurora-Postgres-v1" ]; then rm -Rf ./Amazon-RDS-Aurora-Postgres-v1; fi
if [ -d "./cloudformation" ]; then rm -Rf ./cloudformation; fi
if [ -d "./bin" ]; then rm -Rf ./bin; fi

git clone https://github.com/acloudfan/Amazon-RDS-Aurora-Postgres-v1.git

# Copy the cloudformation templates
mkdir cloudformation
cp -r Amazon-RDS-Aurora-Postgres-v1/vpc/*.yml ./cloudformation
cp -r Amazon-RDS-Aurora-Postgres-v1/cluster-basic/*.yml ./cloudformation
cp -r Amazon-RDS-Aurora-Postgres-v1/replicas/*.yml ./cloudformation
cp -rf Amazon-RDS-Aurora-Postgres-v1/pgbench/ pgbench

# Install the tools
cp -r Amazon-RDS-Aurora-Postgres-v1/bin .
chmod -R u+x bin

echo 'Done.'
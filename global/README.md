# Global Database

Create Global DB Clusing using the console
==========================================

# Create the primary cluster - Region 1 e.g., us-west-1
Use the CloudFormation template : global/primary-cluster.yml
Stack name: primary-rdsa-cluster

# Create the VPC in secondary region - Region 2 e.g., us-west-2
Use the CloudFormation template : vpc/secondary-vpc-sg.yml
Stack name: seondary-rdsa-cluster

# Go to the us-west-2 
Use console to add it as the region to Global database
Global cluster ID  : global-rdsa
Select the VPC: rdsa-vpc
Select the SG: rdsa-sg
Select the instance: db.r4.large

Global cluster becomes available in all region in the console.

# Setup bastion hosts in the VPC
Use the CloudFormation template in both region
Template : vpc/bastion-host.yml
Stack name: rdsa-host

# Download Bastion script for 
curl https://raw.githubusercontent.com/acloudfan/Amazon-RDS-Aurora-Postgres-v1/master/bin/install/setup-bastion.sh --output setup-bastion.sh 

chmod u+x ./setup-bastion.sh 

./setup-bastion.sh us-west-2   global-rdsa-cluster



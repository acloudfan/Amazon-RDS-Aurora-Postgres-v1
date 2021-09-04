cluster-vpc-2-az.yml
====================
Creates the VPC with 2 private & 2 public subnets across 2 AZ

cluster-vpc-3-az.yml
====================
Creates the VPC with 3 private & 3 public subnets across 3 AZ

bastion-host.yml
================
Sets up an EC2 instance that is used for connecting/testing the cluster

Tools
=====
1. git client
2. psql
3. pgbench
4. jq


Setup tools on VM
=================
1. SSH into the VM

2. Install git
sudo su -
yum install git -y

3. Clone the repository
su ec2-user
cd ~
git clone https://github.com/acloudfan/Amazon-RDS-Aurora-Postgres-v1.git

4. Install the tools
cp -r Amazon-RDS-Aurora-Postgres-v1/bin .
chmod -R u+x bin
sudo ./bin/install/psql-pgbench-jq.sh

5. Validate the tools
psql --version
pgbench --version
jq --version

6. Setup environment variables in .bashrc

./bin/setup-env.sh  <<AWS REGION>>
source ~/.bashrc

6. Test with psql
psql

Bastion Host Setup Script
=========================
This method will setup the tools and all required scripts on your bastion host !!


#1 Login to your Bastion Host VM as ec2-user
Copy and paste the commands in shell prompt on your bastion host

#2
curl https://raw.githubusercontent.com/acloudfan/Amazon-RDS-Aurora-Postgres-v1/master/bin/install/setup-bastion.sh --output setup-bastion-host.sh 

#3
chmod u+x ./setup-bastion-host.sh 

#4
./setup-bastion-host.sh <<Provide AWS Region>>   <<Provide DB Cluster ID>>

If you don't see a message "Using the PG_CLUSTER_ID=.." then probably you have provided a wrong cluster name. Just run the script again with the correct name.

#5
source ~/.bashrc

#6
psql                                  <<Uses $PGWRITEREP; Will give error in secondary region in case of global DB>>
psql    -h $PGWRITEREP                <<Will give error in secondary region in case of global DB>>
psql    -h $PGREADEREP

Note: 
In case of error: Make sure to provide the correct AWS Region & Cluster name ; Run the script again



Windows Bastion Host
====================

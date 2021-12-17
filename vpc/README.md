====================
cluster-vpc-2-az.yml
====================
Creates the VPC with 2 private & 2 public subnets across 2 AZ

PS: In videos I am using this template

====================
cluster-vpc-3-az.yml
====================
Creates the VPC with 3 private & 3 public subnets across 3 AZ

PS: Use this template for your own experimentation

================
bastion-host.yml
================
Sets up an EC2 instance that is used for connecting/testing the cluster. 

Stack deletion: 
---------------
The stack creates a Host Security group that is used by other bastion hosts etc. So if you try to delete the stack, you may get an error. To resolve it first delete the resources that have a dependency on the Security group and then delete this stack 


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
su - ec2-user

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

Common Error
------------
If you missed the step below then you will get an error: 
"psql: could not connect to server: No such file or directory"

source ~/.bashrc






Windows Bastion Host
====================
AMI used:
Windows_Server-2019-English-Full-Base-2021.08.11(ami-0a727a421bd5a51a3)

1. Use the AWS console to setup a windows EC2 instance
2. Instance in the public subnet  (Public Subnet A or B)
3. Use the Security group for the Bastion
4. Setup Internet Explorer security to enable file download

Install PgAdmin
---------------
1. Google for "pgadmin"
https://www.postgresql.org/ftp/pgadmin/pgadmin4/v5.6/windows/

2. Download installation exe for Windows
3. Install PgAdmin
4. Test PgAdmin with the existing cluster

References:
1. Windows EC2 IE not allowing file download
https://aws.amazon.com/premiumsupport/knowledge-center/ec2-windows-file-download-ie/

2. Download and install PgAdmin
https://www.postgresql.org/ftp/pgadmin/pgadmin4/v5.6/windows/



Bastion Host Setup Utility Script
==================================
This method will setup the tools and all required scripts on your bastion host !! You may setup you own instance and just follow the steps here to setup the bastion host with required tools.


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



CloudFormation Latest AMI for Linux2
====================================
https://aws.amazon.com/blogs/compute/query-for-the-latest-amazon-linux-ami-ids-using-aws-systems-manager-parameter-store/


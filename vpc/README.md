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
git clone https://github.com/acloudfan/Amazon-RDS-Aurora-v1.git

4. Install the tools
cd A*
chmod u+x ./bin/install/*.sh
sudo ./bin/install/psql-pgbench-jq.sh

5. Setup environment variables in .bashrc
chmod u+x ./bin/install/*.sh
./bin/setup-env.sh
source ~/.bashrc

6. Test with psql
psql




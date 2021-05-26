cluster-vpc-2-az.yml
===============
Creates the VPC with 2 private & 2 public subnets across 2 AZ

cluster-vpc-3-az.yml
===============
Creates the VPC with 3 private & 3 public subnets across 3 AZ


Setup tools on VM
=================
1. SSH into the VM

2. Install git
yum install git -y

3. Clone the repository
git clone https://github.com/acloudfan/Amazon-RDS-Aurora-v1.git

4. Install the tools
cd A*
chmod u+x ./bin/install/*.sh
sudo ./bin/install/psql-pgbench-jq.sh




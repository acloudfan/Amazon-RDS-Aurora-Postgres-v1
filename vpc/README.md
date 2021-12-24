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

=====
Tools
=====
These tools will be installed on the bastion host.
1. git client
2. psql
3. pgbench
4. jq

======================================
Setup tools on VM/Bastion Host (Linux)
======================================
1. SSH into the VM

2. Install git
sudo su -
yum install git -y

3. Clone the repository
su - ec2-user

git clone https://github.com/acloudfan/Amazon-RDS-Aurora-Postgres-v1.git

4. Install the tools
cp -r Amazon-RDS-Aurora-Postgres-v1/bin .
mkdir cloudformation
cp -r Amazon-RDS-Aurora-Postgres-v1/vpc/*.yml ./cloudformation
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

==========================
Setup Windows Bastion Host
==========================

Manual creation
---------------
1. Use the AWS console to setup a windows EC2 instance
2. Instance in the public subnet  (Public Subnet A or B)
3. Use the Security group for the Bastion
4. Setup Internet Explorer security to enable file download

CloudFormation Template (preferred)
-----------------------------------
1. In CloudFormation console create a new stack
   * Upload the YML - vpc/bastion-host-windows.yml
2. Select the name of the KEY  (required)
3. Set the template name = rdsa-bastion-host-windows
4. Select the subnet as PublicSubnetA or PublicSubnetB
5. Select the rdsa VPC
6. Check the acknowledge box
7. Click on create stack

Install PgAdmin
---------------
1. Allow Internet Explorer to download files. Follow instructions at the link below:
https://aws.amazon.com/premiumsupport/knowledge-center/ec2-windows-file-download-ie/

2. Google for "pgadmin"
   Or use the link: https://www.pgadmin.org/download/

3. Download pgAdmin installation exe for Windows
4. Install PgAdmin by following the instructions
5. Test PgAdmin with the Aurora DB cluster
6. (Optional) Install other tools such psql

================================================
(Auto) Bastion Host Setup Utility Script (Linux)
================================================
This method will setup the tools and all required scripts on your bastion host !! You may setup you own instance and just follow the steps here to setup the bastion host with required tools.


1. Login to your Bastion Host VM as ec2-user
--------------------------------------------
Copy and paste the commands in shell prompt on your bastion host

2. Download the setup script
----------------------------
curl https://raw.githubusercontent.com/acloudfan/Amazon-RDS-Aurora-Postgres-v1/master/bin/install/setup-bastion.sh --output setup-bastion-host.sh 

3 Change mod of the file
------------------------
chmod u+x ./setup-bastion-host.sh 

4. Setup the environment
------------------------
./setup-bastion-host.sh <<Provide AWS Region>>  

If you don't see a message "Using the PG_CLUSTER_ID=.." then probably you have provided a wrong cluster name. Just run the script again with the correct name.

5. Set the environment variables in the current shell
-----------------------------------------------------
source ~/.bashrc

7. Use psql
-----------
psql                                  <<Uses $PGWRITEREP; Will give error in secondary region in case of global DB>>
psql    -h $PGWRITEREP                <<Will give error in secondary region in case of global DB>>
psql    -h $PGREADEREP

Note: 
In case of error: Make sure to provide the correct AWS Region & Cluster name ; Run the script again


================================
IE Download issue on Windows/EC2
================================
By default Windows EC2 IE does not allow file downloads.
To fixe the issue follow instructions available at the link below:
https://aws.amazon.com/premiumsupport/knowledge-center/ec2-windows-file-download-ie/

1.Connect to your EC2 Windows instance.
2.Open the Windows Start menu, and then open Server Manager.
3.Follow the instructions for the Windows Server: 
  * Choose Local Server from the left navigation pane. 
  * For IE Enhanced Security Configuration
4.For Administrators & Users, select Off - Choose OK.
5.Close Server Manager. 

============================
Download and install PgAdmin
============================
https://www.pgadmin.org/download/

====================================
CloudFormation Latest AMI for Linux2
====================================
https://aws.amazon.com/blogs/compute/query-for-the-latest-amazon-linux-ami-ids-using-aws-systems-manager-parameter-store/


===================================
CloudFormation Dependencies for VPC
===================================
1. Terminate all instances in your VPC
2. Delete all ENI's associated with subnets within your VPC
3. Detach all Internet and Virtual Private Gateways (you can then delete them and any VPN connections, but that's not required to delete the VPC object)
3. Disassociate all route tables from all the subnets in your VPC
4. Delete all route tables other than the "Main" table
5. Disassociate all Network ACL's from all the subnets in your VPC
6. Delete all Network ACL's other than the Default one
7. Delete all Security groups other than the Default one (note: if one group has a rule that references another, you have to delete that rule before you can delete the other security group)
8. Delete all subnets
9. Delete your VPC
10. Delete any DHCP Option Sets that had been used by the VPC
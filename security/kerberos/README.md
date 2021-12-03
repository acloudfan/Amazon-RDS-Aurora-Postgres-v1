=========================
Part-1 Setup Microsoft AD
=========================
Follow instructions at the following link to create an instance of the AD

https://aws-labs.net/winlab2-managedad/install-mad.html

=================================
Part-2 Setup AD Management Server
=================================
Windows EC2 instance for managing users in the active directory.
Use the instructions available here: https://aws-labs.net/winlab2-managedad/admin-mad.html

Create a user: ad_dbuser

===========================================================
Part-3 Configure Aurora Postgres to use Kerberos/Managed AD
===========================================================
Using Kerberos Authentication
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/postgresql-kerberos.html


1. Create the role that Aurora Cluster will use for connecting with AD

aws iam create-role --role-name rdsa-kerberos-role --assume-role-policy-document file://trust-policy.json 

aws iam put-role-policy --role-name  rdsa-kerberos-role --policy-name rdsa-ad-policy --policy-document file://ad-policy.json

2. Modify the DB Cluster
Modify the cluster to 
aws rds  modify-db-cluster --db-cluster-identifier rdsa-postgresql-cluster --domain <<get the directory ID d-xxxx>>  --domain-iam-role-name rdsa-kerberos-role

3. Reboot the instances in the cluster
=========================================
Part-4  Connect from psql on Bastion host
=========================================

CREATE ROLE "ad_dbuser@awsad.com" WITH LOGIN;
GRANT rds_ad TO "ad_dbuser@awsad.com";


1. Install Kerberos Client on EC2

sudo yum install krb5-workstation krb5-libs krb5-auth-dialog

2. 


Quick start for Managed AD
https://aws-quickstart.github.io/quickstart-microsoft-activedirectory/#_launch_the_quick_start

Using SSM port forwarding for RDP
https://aws-quickstart.github.io/quickstart-microsoft-iis/#_testing_the_deployment


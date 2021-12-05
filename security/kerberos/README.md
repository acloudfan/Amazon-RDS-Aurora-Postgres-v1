=========================
Part-1 Setup Microsoft AD
=========================
Follow instructions at the following link to create an instance of the AD

https://aws-labs.net/winlab2-managedad/install-mad.html

This creates a security group in the VPC with the name : 
<<Directory ID>>_controllers

You may adjust the security group to control the AD access.

Domain created : AWSAD.COM

PDF Version of the Lab: workshop/Setup-AWS-Managed-AD.pdf

=================================
Part-2 Setup AD Management Server
=================================
Create a Windows EC2 instance for managing users in the active directory.
As AD admin, log into the Windows server & add the user to AD domain:

User created : awsad\ad_dbuser


Use the instructions available here: 
https://aws-labs.net/winlab2-managedad/admin-mad.html

PDF Version of the Lab: workshop/Administer-AWS-Managed-AD.pdf

===========================================================
Part-3 Configure Aurora Postgres to use Kerberos/Managed AD
===========================================================

Using Kerberos Authentication
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/postgresql-kerberos.html

When a new Cluster is created with Kerberos enabled, RDS/Aurora create the role automatically, but if existing cluster is modified then the role needs to be provided.

1. Create the role that Aurora Cluster will use for connecting with AD
----------------------------------------------------------------------

$ aws iam create-role --role-name rdsa-kerberos-role --assume-role-policy-document file://trust-policy.json 

$ aws iam put-role-policy --role-name  rdsa-kerberos-role --policy-name rdsa-ad-policy --policy-document file://ad-policy.json

2. Modify the DB Cluster
------------------------
Make sure to replace the directory ID and paste in the command

$ aws rds  modify-db-cluster --db-cluster-identifier rdsa-postgresql-cluster --domain <<get the directory ID d-xxxx>>  --domain-iam-role-name rdsa-kerberos-role

3. Reboot the instances in the cluster
--------------------------------------
$ aws rds reboot-db-instance --db-instance-identifier rdsa-postgresql-node-01

4. Verify that kerberos is enable
---------------------------------
aws rds describe-db-instances --db-instance-identifier rdsa-postgresql-node-01 | grep kerber

==================================================
Part-4 Setup a user on Aurora/PG for Kerberos auth
==================================================
=> CREATE USER  "ad_dbuser@AWSAD.COM" WITH LOGIN;
=> GRANT rds_ad TO "ad_dbuser@AWSAD.COM";

============================================
Part-5  Connect from psql on Management host
=============================================
* Install pgAdmin
* (optional) Install PostgreSQL 

1. Login into the AD management machine as ad_dbuser
----------------------------------------------------
RDP to management server

2. Try out psql
---------------
$ psql -U ad_dbuser@AWSAD.COM postgres

3. Setup pgAdmin
----------------
Try it out



=======
Cleanup
=======
1. Modify the cluster to disable Kerberos

2. Delete thr IAM policy and role

3. Delete the role : ad_dbuser

4. Terminate the Windows management server

5. Delete the AWS managed directory




========================
Client side requirement
========================
* Client machine must be in AD domain
  Since the Bastion hosts are not in the AD domain, they will throw error
* AD user to be authenticated on PG must be logged in


========================================
RDS PG/Kerberos Setup : High level steps
========================================
1. Setup AWS Managed Aactive Directory (AD)
2. Setup an AD management server
3. Add a user to AD domain  (db user)
4. Allow AD user to log on to management server
   * As admin : Control Panel >> Allow remote access to your computer
     * Select Users ... select the (db user) in AD 
   * Look for the user created in step#3
5. Modify cluster to allow kerberos
    * Define a role
    * Enable Kerberos - select the directory
6. Setup user on Aurora Cluster
7. Log onto the management server as (db user)
    * Install pgAdmin, psql ... other tools
8. Use pgAdmin/psql to connect to Postgres using kerberos

===============
Kerberos on EC2
===============
1. Install Kerberos Client on EC2

sudo yum install krb5-workstation krb5-libs krb5-auth-dialog

2. krb5.conf file has the AD settings

3. Added IP address for AWSAD

4. Kinit
KRB5_CONFIG="$PWD/krb5.conf" kinit ad_dbuser
KRB5_CONFIG="$PWD/krb5.conf" klist



https://www.enterprisedb.com/blog/how-set-kerberos-authentication-using-active-directory-postgresql-database

Quick start for Managed AD
https://aws-quickstart.github.io/quickstart-microsoft-activedirectory/#_launch_the_quick_start

Using SSM port forwarding for RDP
https://aws-quickstart.github.io/quickstart-microsoft-iis/#_testing_the_deployment

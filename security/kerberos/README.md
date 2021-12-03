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

aws iam put-role-policy --role-name role-example --policy-name rdsa-ad-policy --policy-document file://ad-policy.json



aws rds  modify-db-cluster --db-cluster-identifier <<mydbinstance>> --domain <<d-Directory-ID>> --domain-iam-role-name <<role-name >>


Quick start for Managed AD
https://aws-quickstart.github.io/quickstart-microsoft-activedirectory/#_launch_the_quick_start

Using SSM port forwarding for RDP
https://aws-quickstart.github.io/quickstart-microsoft-iis/#_testing_the_deployment


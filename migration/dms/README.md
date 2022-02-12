==================================
Exercise: Setup MySQL & Endpoints
Part-1 Install MySQL on Linux Host
==================================
The Linux Bastion Host Security group allows connections from within VPC

1. Install the MySQL server
---------------------------
* Log on to the Linux Bastion Host
* Assuming that user is logged in as ec2-user

sudo yum update -y

# MariaDB is community managed MySQL
sudo yum install mariadb-server -y

# Start the server
sudo systemctl start mariadb


# Run the command below if ONLY if you want MariaDB to restart on host reboot
# sudo systemctl enable mariadb

2. Setup root password
----------------------
# Set the password
sudo mysql_secure_installation
    - Enter current password for root (enter for none): <<Hit enter>>
    - Set root password?  =  n
    - Remove anonymous users? = Y
    - Disallow root login remotely?  = n
    - Remove test database and access to it? = Y
    - Reload privilege tables now? = Y

3. Setup a user for DMS to use
------------------------------
* Connect to the mysql server

mysql -u root -p -h localhost

mysql=>

CREATE USER 'dms_user'@'%' IDENTIFIED  BY 'password';

GRANT ALL PRIVILEGES ON *.* TO 'dms_user'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

mysql=>
SYSTEM mysql -u dms_user -p
SELECT user();

=================================
Exercise: Setup MySQL & Endpoints
Part-2 Create the  Endpoints
=================================
Open the DMS Console

1. Source endpoint for MySQL
----------------------------
* Select 'Endpoints' in left navigation panel
* Create new 'Source' endpoint
    - Name = mysql-on-bastion-host
    - Description = mysql-on-bastion-host
    - Source Engine = Select MySQL
    - Access to endpoint = 'Provide access information manually'
    - Server name = <<Copy/paste Windows Bastion Host DNS>>
    - Port = 3306
    - User = dms_user
    - Password = password
* Click on create endpoint

2. Target endpoint for Aurora PostgreSQL
----------------------------------------
* Select 'Endpoints' in left navigation panel
* Create new 'Target' endpoint
    - Name = rdsa-postgresql-cluster
    - Description = rdsa-postgresql-cluster
    - Source Engine = Select 'Amazon Aurora PostgreSQL'
    - Access to endpoint = 'Provide access information manually'
    - Server name = Copy/paste Cluster EP for 'rdsa-postgresql-cluster'
    - Port = 5432
    - User = masteruser
    - Password = masteruserpw
* Click on create endpoint


=====================================================
Exercise: Setup Replication instance & Test Endpoints
Part-1 Setup replication instance
=====================================================

* Please ensure MySQL is running
sudo systemctl start mariadb

1. Populate the MySQL database
------------------------------
* Logon to the bastion host
* Populate the MySQL database

* Start the MySQL session, provide 'password'
mysql -u dms_user  -p -h localhost  

* Create the database
DROP DATABASE sakila; 
CREATE DATABASE sakila;

* Setup the schema
source Amazon-RDS-Aurora-Postgres-v1/migration/dms/schemas/sakila-schema.sql 

* Populate the database
source Amazon-RDS-Aurora-Postgres-v1/migration/dms/schemas/sakila-data.sql 

* Verify
SELECT count(*) FROM film;

2. Setup Replication Instance
-----------------------------
* Open DMS console
* Select 'Replication instance' in left navigation panel
* Click on 'Create Replication Instance'
    Leave all defaults except for the following.
    - Name = rdsa-dms-replication-instance
    - Description = rdsa-dms-replication-instance
    - Allocated storage = 30 GiB
    - VPC = Select the RDSA VPC
    - Multi AZ = Select 'Dev or test workload (Single AZ)'
    - Publicly accessible = Uncheck
* A default "Subnet Group" will be created automatically
* You may create/specify a subnet group


=====================================================
Exercise: Setup Replication instance & Test Endpoints
Part-2 Test source & target endpoints
=====================================================






=====================================================
Exercise: Setup Replication task
Part-1 Setup replication instance
=====================================================


2. Setup schema on Aurora Postgres labdb - pagila 
-------------------------------------------------

psql -c 'drop schema pagila cascade'
psql -c 'CREATE SCHEMA pagila'

psql  <  Amazon-RDS-Aurora-Postgres-v1/migration/sct/schema-conversion/3.manual-converted-sakila-postgresql.sql








=======================
Create Replication Task
=======================
* Open DMS console
* Select 'Database migration task' in left navigation panel
* Click on 'Create task'
    - Name = rdsa-mysql-to-postgresql
    - Description = rdsa-mysql-to-postgresql
    - Replication instance = rdsa-dms-replication-instance
    - Source = Select the mysql source endpoint
    - Target = Select the Postgres target endpoint
    - Migration type = 'Migrate existing data and replicate ongoing changes'

    - Custom CDC stop mode for source transactions = 'Disable custom CDC stop mode'
    - Target table preparation mode = 'Do nothing'
    - Stop task after full load completes = 'Don't stop'
    - Include LOB columns in replication = 'Full LOB mode'

===========================
Enable CW Logs for the task
===========================

1. Create the role for CW
dms-cloudwatch-logs-role


============================================
If you are using MySQL instead of MariaDB
as there is a minor difference in user setup
Setup DMS user on MySQL 
============================================
* Log on to Windows Bastion host
* Launch mysql command line tool
* Run the following commands

mysql=>

CREATE USER 'dms_user'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'dms_user'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

mysql=>
SYSTEM mysql -u dms_user -p
SELECT user();


===================
MySQL binlog_format
===================
* DMS requires the MySQL binlog_format=row
* Verfy by launching MySQL
=> select @@global.binlog_format;

* If it is not row then edit the mysql.ini or mysql.conf
binlog_format=ROW

* Restart the database after the config change



References:
https://docs.aws.amazon.com/dms/latest/userguide/Welcome.html

CloudFormation
https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Introduction.AWS.html

Migration guides
https://docs.aws.amazon.com/dms/latest/sbs/dms-sbs-welcome.html

DMS Running with errors
https://aws.amazon.com/premiumsupport/knowledge-center/dms-task-error-status/

Enable logging
https://aws.amazon.com/premiumsupport/knowledge-center/manage-cloudwatch-logs-dms/

https://aws.amazon.com/premiumsupport/knowledge-center/dms-enable-debug-logging/
https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Troubleshooting.html#CHAP_Troubleshooting.General.CWL



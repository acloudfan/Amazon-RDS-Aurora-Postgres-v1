==================================
Exercise: Setup MySQL & Endpoints
Part-1 Install MySQL on Linux Host
==================================
The Linux Bastion Host Security group allows connections from within VPC
NOTE: Video created with MariaDB vserion = 5.5.68-MariaDB 

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
* Video was done with version = 5.5.68-MariaDB 

mysql -u root -p -h localhost
select @@global.version;

mysql=>

CREATE USER 'dms_user'@'%' IDENTIFIED  BY 'password';

GRANT ALL PRIVILEGES ON *.* TO 'dms_user'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

mysql=>
SYSTEM mysql -u dms_user -p
SELECT user();


Part-2 Create the  Endpoints
============================
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
PS: We will use a utility script but if you want to use DMS console
please follow the instructions later in this README file.

1. Create the DMS roles
-----------------------
* DMS requires multiple roles for tasks
* These roles get created automatically if you are using DMS console
* Need to be created manually for AWS CLI
* Needs to be done once unless you delete the role

./bin/dms/create-dms-roles.sh

* To delete the roles you may use
* Delete will fail if roles are in use

./bin/dms/delete-dms-roles.sh

Part-2 Setup replication instance
=================================

1. Create the Replication Subnet Group
--------------------------------------
* Use the utility script to create the subnet group
* This script reads the comma separated list of private subnets from
* VPC CloudFormation stack

./bin/dms/create-subnet-group.sh

2. Create the Replication instance
----------------------------------
* Run the utility script
* Uses the subnet created in #1

./bin/dms/create-replication-instance.sh



Part-3 Test the Endpoints
=========================

1. Test the Source endpoint
---------------------------
* Log on to Bastion host & make sure MySQL is running
sudo systemctl start mariadb

2. Test the Target endpoint
---------------------------
* Log on to DMS console

=================================
Exercise: Setup Replication Task
=================================
PS: We will use utility script but you may use DMS console 


Part-1 Prepare the Source Database
==================================
DMS has certain requirements for source databases thar depends on the 
source DB engine. As part of the planning user needs to ensure that
all requirements are met.


1. DMS Requires binlog_format=ROW
---------------------------------
* Replication Task will fail without this setup
https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.MySQL.html#CHAP_Source.MySQL.Prerequisites 

# Stop MySQL
sudo systemctl stop mariadb

# Copy the config file
sudo cp /etc/my.cnf  /etc/my.cnf.backup
sudo cp ./Amazon-RDS-Aurora-Postgres-v1/migration/dms/schemas/mysql-binlog.cnf  /etc/my.cnf

# Start MySQL
sudo systemctl   start   mariadb
PS: If you get an error, do the followin:
    sudo vi /etc/my.cnf
    <esc> :  w  q
    sudo systemctl   restart   mariadb

# Confirm bin log format - it should be ROW
mysql -u root -e 'select @@global.binlog_format;'


2. Create the database : sakila
-------------------------------
# Drop the database
mysql -u root -e 'DROP DATABASE IF EXISTS sakila;'

# Create the database
mysql -u root -e 'CREATE DATABASE sakila;'

3. Setup the database schema and populate
-----------------------------------------
# Setup schema & Populate the database with some test data
mysql -u root < ./Amazon-RDS-Aurora-Postgres-v1/migration/dms/schemas/sakila-schema.sql 
mysql -u root < ./Amazon-RDS-Aurora-Postgres-v1/migration/dms/schemas/sakila-data.sql 

# Verify the load
mysql -u root -e 'USE sakila; SELECT count(*) FROM film;'


Part-2 Prepare the Target Database
==================================

1. Setup schema on Aurora Postgres labdb - pagila 
-------------------------------------------------

psql -c 'drop schema pagila cascade'
psql -c 'CREATE SCHEMA pagila'

psql  <  ./Amazon-RDS-Aurora-Postgres-v1/migration/dms/schemas/pagila-postgresql-ddl-no-constraints.sql


Part-3 Setup the replication task
=================================
* Requires the Replication instance to be running
* If you deleted it, please create it before the next step

1. Run the utility script
-------------------------
* Utility script takes the Task-Settings and Task-Mapping as parameters

./bin/dms/create-replication-task.sh \
    file://./Amazon-RDS-Aurora-Postgres-v1/migration/dms/json/task-setting.json \
    file://./Amazon-RDS-Aurora-Postgres-v1/migration/dms/json/1.task-mapping.json   
    


2. Verify the Replication Task
------------------------------
* Target table preparation mode
    - Modify task so that it is "Do nothing"

* Enable CloudWatch logs
    - Check the box

* Stop task after full load completes
    - Modify so that its is "Stop task after full load completes"

* Save if you have made any changes

3. Run the replication task
---------------------------
* Select the task on DMS console

* Actions >> Restart/Resume
  

4. Checkout the job status in DMS console
-----------------------------------------
* It should be stopped with no errors

* Verify count in pagila.film
psql -c 'SELECT COUNT(*) FROM pagila.film;'

It will be 0 ????

Root cause of the issue
=======================

Issue is due to the fact that DMS is writing out to the default schema in Postgres. So it created the schema sakila in Postgres and populated the data in it BUT that is not what we want.

# Run this to see the tables created by DMS - notice the 'hasindexes'
psql -c "SELECT * FROM pg_tables WHERE schemaname = 'sakila';"

# Checkout the data in the sakila schema
psql -c 'SELECT COUNT(*) FROM sakila.film;'

Solution to this issue will be addressed in next exercise.


=====================================
Exercise: Fix Replication Task Errors
=====================================
Reason for the error:
The sakila.payment table definition has a last_update column 
which is not there in pagila.payment. As a result when DMS tries
to insert in into the target its fails !!!

Solution:
Create a mapping rule that will drop the column : last_update

1.Cleanup the Postgresql setup
------------------------------
* Drop the  schema: sakila created due to earlier run
psql -c 'DROP SCHEMA sakila cascade'

2.Stop & Delete the replication task
------------------------------------
* Use DMS console to stop the task

./bin/dms/delete-replication-task.sh


3. Run the utility script for creation with a different task-mapping.json
-------------------------------------------------------------------------

./bin/dms/create-replication-task.sh \
    ./Amazon-RDS-Aurora-Postgres-v1/migration/dms/json/2.task-mapping.json   \
    ./Amazon-RDS-Aurora-Postgres-v1/migration/dms/json/task-setting.json

* Checkout the mapping rule for last_update column

4. Verify, & Modify 
-------------------
* Target table preparation mode
    - Modify so that it is "Do nothing"

* Stop task after full load completes
    - Modify so that its is "Stop task after full load completes"

5. Apply the constraints
------------------------

psql  <  Amazon-RDS-Aurora-Postgres-v1/migration/dms/schemas/pagila-postgresql-add-constraints-indexes.sql

6.Insert rows to MySQL/Sakila database
--------------------------------------
# Check the number of rows in film table in Sakila
mysql -u root -e 'use sakila; SELECT COUNT(*) FROM film;'

# Check number of rows in film table Pagila
psql -c 'SELECT COUNT(*) FROM pagila.film;'

# Insert 10 rows
mysql -u root < ./Amazon-RDS-Aurora-Postgres-v1/migration/dms/schemas/sakila-data-add-film.sql

# Check count in sakila and pagila
mysql -u root -e 'use sakila; SELECT COUNT(*) FROM film;'
psql -c 'SELECT COUNT(*) FROM pagila.film;'


=====================================
Create Replication Instance using DMS
=====================================
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


======================================
Create Replication Task in DMS console
======================================
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
sudo systemctl restart mariadb


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
https://aws.amazon.com/premiumsupport/knowledge-center/dms-cloudwatch-logs-not-appearing/
https://aws.amazon.com/premiumsupport/knowledge-center/dms-enable-debug-logging/
https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Troubleshooting.html#CHAP_Troubleshooting.General.CWL

Troubleshooting MySQL binlog issue
https://aws.amazon.com/premiumsupport/knowledge-center/dms-binary-logging-aurora-mysql/


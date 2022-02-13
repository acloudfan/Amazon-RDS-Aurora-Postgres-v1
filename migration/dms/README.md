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



Part-2 Test the Endpoints
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
Part-1 Setup replication instance
=================================
PS: We will use utility script but you may use DMS console 


1. Populate the MySQL database
------------------------------
* Logon to the bastion host
* Please ensure MySQL is running

    sudo systemctl start mariadb

* Populate the MySQL database

* Start the MySQL session, provide 'password'

mysql -u dms_user  -p -h localhost  

-- Create the database
DROP DATABASE sakila; 
CREATE DATABASE sakila;

-- Setup the schema
source ./Amazon-RDS-Aurora-Postgres-v1/migration/dms/schemas/sakila-schema.sql 

-- Populate the database
source ./Amazon-RDS-Aurora-Postgres-v1/migration/dms/schemas/sakila-data.sql 

* Verify
SELECT count(*) FROM film;


2. Setup schema on Aurora Postgres labdb - pagila 
-------------------------------------------------

psql -c 'drop schema pagila cascade'
psql -c 'CREATE SCHEMA pagila'

psql  <  Amazon-RDS-Aurora-Postgres-v1/migration/dms/schemas/pagila-postgresql-ddl-no-constraints.sql


3. Setup MySQL binlog format
----------------------------
* Checkout pre-requisites for MySQL
https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.MySQL.html#CHAP_Source.MySQL.Prerequisites 


sudo nano /etc/my.cnf

* Add following under the section [mysqld] and save
binlog_format=row
server-id=2
log-bin=/var/tmp/MySql_Logs/BinLog
log_bin=ON
expire_logs_days=1
binlog_checksum=NONE
#binlog_row_image=FULL
log_slave_updates=true

* Restart MariaDB
sudo systemctl restart mariadb

* Confirm if binlog_format = row
mysql -u root -p -h localhost
select @@global.binlog_format;

4. Setup the replication task
-----------------------------
* Run the utility script
./bin/dms/create-replication-task.sh \
    ./Amazon-RDS-Aurora-Postgres-v1/migration/dms/json/1.task-mapping.json   \
    ./Amazon-RDS-Aurora-Postgres-v1/migration/dms/json/task-setting.json

5. Verify, & Modify 
-------------------
* Target table preparation mode
    - Modify so that it is "Do nothing"

* Stop task after full load completes
    - Modify so that its is "Stop task after full load completes"

* Enable CloudWatch logs
    - Check the box

* Save    

6. Run the replication task
---------------------------
* Select the task on DMS console

* Actions >> Restart/Resume
  Select Restart

7. Checkout the job status in DMS console
-----------------------------------------
* There will be an error :)

Can you identify the issue?

Hints:
* Check the table statistics
* Check the CloudWatch logs
* Check the Postgres Logs 
* Compare schema for failed table

Note: Solution is in next hands on exercise


=====================================
Exercise: Fix Replication Task Errors
=====================================
Reason for the error:
The sakila.payment table definition has a last_update column 
which is not there in pagila.payment. As a result when DMS tries
to insert in into the target its fails !!!

Solution:
Create a mapping rule that will drop the column : last_update

1.Stop & Delete the replication task
------------------------------------
* Use DMS console to stop the task

./bin/dms/delete-replication-task.sh

2.Cleanup the Postgresql setup
------------------------------

psql -c 'drop schema pagila cascade'
psql -c 'CREATE SCHEMA pagila'

psql  <  Amazon-RDS-Aurora-Postgres-v1/migration/dms/schemas/pagila-postgresql-ddl-no-constraints.sql


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
* Check the number of rows in film table in Sakila
mysql -u root -e 'use sakila; SELECT COUNT(*) FROM film;'

* Check number of rows in film table Pagila
psql -c 'SELECT COUNT(*) FROM pagila.film;'

* Insert 10 rows
mysql -u root < ./Amazon-RDS-Aurora-Postgres-v1/migration/dms/schemas/sakila-data-add-film.sql

* Check count in sakila and pagila
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




====================
Setup schema : pagila 
=====================

psql -c 'drop schema pagila cascade'
psql -c 'CREATE SCHEMA pagila'

psql  <  Amazon-RDS-Aurora-Postgres-v1/migration/sct/schema-conversion/3.manual-converted-sakila-postgresql.sql

=======================
Setup DMS user on MySQL
=======================
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


==================================================
(Optional) Test MySQL connectivity from Linux Host
==================================================
The Windows Bastion Host Security group allows connections from within VPC
The idea of this part is to confirm the connectivity.

* Log on to the Linux Bastion Host
sudo su -
yum install mysql

* Connect to MySQL on windows host

mysql -u root -p -h << Private host_name or Ip-address of Windows Bastion Host>>

* If you are unable to connect to it then there is a problem !!

===========================
Create Replication instance
===========================
* Open DMS console
* Select 'Replication instance' in left navigation panel
* Click on 'Create Replication Instance'
    Leave all defaults except for the following.
    - Name = rdsa-dms-replication-instance
    - Description = rdsa-dms-replication-instance
    - VPC = Select the RDSA VPC
    - Multi AZ = Select 'Dev or test workload (Single AZ)'
    - Publicly accessible = Uncheck



================
Create endpoints
================

1. Source endpoint for MySQL
----------------------------
* Open the DMS Console
* Select 'Endpoints' in left navigation panel
* Create new 'Source' endpoint
    - Name = mysql-on-windows
    - Description = mysql-on-windows
    - Source Engine = Select MySQL
    - Access to endpoint = 'Provide access information manually'
    - Server name = Copy/paste Windows Bastion Host DNS
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



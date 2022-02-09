SQL Files
=========
(1) sakila-schema-mysql.sql
Original source schema downloaded from SCT

(2) automatic-converted-sakila-postgresql
SCT converted schema to PostgreSQL

(3) manual-converted-sakila-postgresql.sql
Manually adjusted sakila schema 

=============================
Install - SCT, MySQL
Connect SCT to MySQL database
=============================

Part-1 Install Schema Conversion tool
-------------------------------------
1. Start the Windows based Bastion Host
   * If you have not set it - please follow instructions under
   /vpc/README.md   Refer: Setup Windows Bastion Host
2. Connect to the bastion host using RDP client
   * Covered in a video in the section "Setup Aurora Cluster"
3. Google for "AWS Schema Conversion Tool"
* You may use Internet Explorer as well :)
https://docs.aws.amazon.com/SchemaConversionTool/latest/userguide/CHAP_Installing.html

4. Download & Install SCT

Part-2 Install and populate MySQL
---------------------------------

1. Download and install MySQL on Windows Bastion host
https://dev.mysql.com/downloads/installer/

* Set the password=<<Something simple to remember e.g., password>>

2. Launch MySQL workbench
* Connect to it by launching 'MySQL Workbench' from windows start menu

3. Download the sample database schema/data
* Google for 'MySQL Sakila database'
* Or use the link below for downloading the zip file with schema and data
* Unzip the sakila zip file
https://dev.mysql.com/doc/sakila/en/sakila-installation.html


4. In the MySQL workbench
* File >> New Query Tab
* Click on 'Folder' icon in query tab & select the sakila schema file
* In left navigation panel 'Data Import/Restore'
* In 'Data Import' tab select 'Import from Self-Contained File'
* Select the sakila data file
* Click on 'Start Import'
* In left navigation panel click on 'Schemas' and checkout data in teh tables

Part-3 Connect SCT to MySQL
---------------------------
1. Copy the JDBC driver
* Create folder   Documents\MySQL\JDBC
* Copy driver jar file:
    From:   C:\Program Files (x86)\MySQL\JDBC
    To:     Documents\MySQL\JDBC

2. Setup SCT project
* Launch SCT
* File >> New project
    - Name = mysql-sakila-to-postgres
* File >> Save project

3. Setup the source
* Click on 'Add source'
    - Select 'MySQL'
    - Connection name = localhost-mysql
    - Server name = localhost
    - Username = root
    - Password = password
    - Store password = check the box
    - MySQL driver path = Documents/MySQL/JDBC

* Click on 'Test connection'
* Acknowledge the risk
* Click on 'Connect'
* Click on 'Main view' button on top



Conversion Example
==================
Example: MySQL to Aurora PostgreSQL 

Install MySQL for testing
-------------------------
https://dev.mysql.com/downloads/installer/

1. Google for "MySQL download"
2. Install MySQL on the Windows host (set root password=password)
3. Copy the JDBC driver to : Documents/MySQL folder

Setup the test database (sakila)
--------------------------------
https://dev.mysql.com/doc/sakila/

1. Google for "MySQL Sakila schema"
2. Download the zip file & extract to the folder Documents/MySQL
3. Open MySQL workbench 
4. Open the query tool, read the schema sql file & execute
5. In the query tool, read the data file & execute

Setup the JDBC Driver for PostgreSQL
------------------------------------
https://jdbc.postgresql.org/download.html

1. On the SCT donwload install page, click on the link for downloading the PostgreSQL driver
2. Download the driver to the folder Documents/PostgreSQL


Launch the SCT tool
-------------------


References
==========

* MySQL sakila sample Database
https://dev.mysql.com/doc/sakila/en/sakila-introduction.html

* Pagila sample Database
https://www.postgresqltutorial.com/postgresql-sample-database/
https://github.com/devrimgunduz/pagila

* Sample database MySQL Sakila & PostgreSQL Pagila
https://www.postgresqltutorial.com/postgresql-sample-database/

* Link for downloading the PostgreSQL JDBC driver
https://jdbc.postgresql.org/download.html
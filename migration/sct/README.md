SCT Installation
================
1. Launch the Windows based Bastion Host
2. Google for "AWS Schema Conversion Tool"
3. Download & Install the tool

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
https://dev.mysql.com/doc/index-other.html

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


Refernces
=========

* MySQL sakila sample Database
https://dev.mysql.com/doc/sakila/en/sakila-introduction.html

* Pagila sample Database
https://www.postgresqltutorial.com/postgresql-sample-database/
https://github.com/devrimgunduz/pagila

* Sample database MySQL Sakila & PostgreSQL Pagila
https://www.postgresqltutorial.com/postgresql-sample-database/
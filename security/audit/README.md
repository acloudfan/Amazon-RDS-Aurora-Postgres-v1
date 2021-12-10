===========
References:
===========
General information
https://www.pgaudit.org/

Setup parameter and usage
https://github.com/pgaudit/pgaudit

=============
Setup PgAudit
=============
1. Setup a custom DB Parameter Group (or use existing)
2. In the custom DB PG setup
    *  Add pgaudit to comman separated list of shared libs
       shared_preload_libraries=...,pgaudit
    * Configure master role for object logging; to be created
        pgaudit.role=rds_pgaudit
3. Apply the custom PG To Aurora cluster and reboot
4. Create the extension
=> CREATE EXTENSION pgaudit;

5. Confirm setup
=> SHOW shared_preload_libraries;
=> \dx  pgaudit;

===============
Session Logging
===============
Logs all statements executed in a session

1. Start watching latest Postgres Log on RDS Console
2. Setup the pgaudit.log equal to statement classes
=> SET pgaudit.log='write, ddl'

* Not logged
=> SELECT count(*) FROM test;

* Logged
=> CREATE table t1 (id int);
=> INSERT INTO t1 VALUES(1);


Check out the statements that are logged.
Try out other statements

==============
Object Logging
==============
Logs object logs

1. Switch off session logging
SET pgaudit.log='';

2. Create the master role that was set earlier in parameter
=> CREATE ROLE rds_pgaudit;
=> GRANT SELECT ON t1 TO rds_pgaudit;
=> GRANT INSERT ON t1 TO rds_pgaudit;

3. Tryout the SQL statements 

* SQLs not logged
=> SELECT count(*) FROM test;
=> INSERT INTO t1 VALUES(1);

* SQLs logged
=> SELECT * FROM t1;
=> DELETE FROM t1;


Check out the statements that are logged.
Try out other statements


References:
* Enabling PgAudit
https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.html#Appendix.PostgreSQL.CommonDBATasks.pgaudit

https://aws.amazon.com/premiumsupport/knowledge-center/rds-postgresql-pgaudit/

Get Privileges for rds_pgaudit
------------------------------
SELECT grantee, privilege_type 
FROM information_schema.role_table_grants 
WHERE  grantee='rds_pgaudit' AND table_name='test' ;
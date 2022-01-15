===================
Postgres Extensions
===================
Prior to v13 only superuser coule manage extensions
In v13, trusted extensions are introduced that may be managed by other ROLE/USER

List available extensions
-------------------------
These are the extensions that may be enabled/disabled on PG

=> SELECT * FROM pg_available_extensions;

List the extensions available on RDS

=> SHOW rds.extensions

List the installed extensions
-----------------------------
=> \dx
=> \dx+

Create extensions
-----------------
https://www.postgresql.org/docs/current/sql-createextension.html
Or install an extension
ONLY available extensions can be installed

=> CREATE EXTENSION <<Extension name>>

DROP extensions
---------------
=> DROP EXTENSION <<Extension name>>

List the versions of extensions
-------------------------------
=> SELECT * FROM pg_available_extension_versions

Upgrade the version of extension
--------------------------------
=> ALTER EXTENSION <<Extension name>> UPDATE TO <<new version>>

Control the creation of extensions on RDS
-----------------------------------------
=> SHOW rds.allowed_extensions


===========================================================
Hands On : PostGis extension for US Address standardization
===========================================================
http://postgis.net/docs/stdaddr.html

https://postgis.net/docs/manual-3.2/postgis_installation.html#installing_pagc_address_standardizer


1. Check if the address_standardizer extension is available
-----------------------------------------------------------

=> SELECT * FROM pg_available_extensions WHERE name='address_standardizer';

2. Create extension 
-------------------

=> CREATE EXTENSION address_standardizer;

3. Try it out
-------------

=> SELECT num, street, city, state, zip
 FROM parse_address('1 Devonshire Place PH301, Boston, MA 02109');

=> SELECT * 
   FROM parse_address('123 Main Street unit 1A , Atlanta, Georgia 90919-1234');

Cleanup
-------
=> DROP EXTENSION address_standardizer;


===============================================
Hands On : S3 export using the aws_s3 extension
===============================================
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/postgresql-s3-export.html

Exercise setup
--------------
* Verify that extension is available
$  psql   -c 'SELECT * FROM pg_available_extensions' | grep aws_s3

* Check if your role is allowed to create extension (v12.6 or later, v13.2 or later)
$  psql   -c 'SHOW rds.allowed_extensions'


1. Setup the S3 bucket and roles using CloudFormation Template
--------------------------------------------------------------

* Set Stack-Name = 'rdsa-s3extension-test'
* Use the template 's3-roles-etension.yml'

2. SSH to Bastion host & Setup the environment variable
-------------------------------------------------------
* If you log out of the terminal then you will need to set these again
export  TEST_BUCKET=<<Copy the value for 'ExtensionRDSATestBucket' from the Cloud Formation Stack>>
export  TEST_ROLE_ARN=<<Copy the value for 'RDSAS3DBClusterRoleArn' from the Cloud Formation Stack>>

3. Add the roles to the DB cluster setup
----------------------------------------

* (Optional) Check feature names; use the appropriate version
aws  rds      describe-db-engine-versions  \
                         --engine           postgres   \
                         --engine-version   13.4  \
                         --query 'DBEngineVersions[0].SupportedFeatureNames';

* Add the role to cluster - will need ARN for role from the stack
aws  rds      add-role-to-db-cluster  \
                         --db-cluster-identifier     $PG_CLUSTER_ID   \
                         --feature-name              s3Export   \
                         --role-arn                  $TEST_ROLE_ARN

(optional) Verify if the role is associated
aws rds describe-db-clusters  --db-cluster-id $PG_CLUSTER_ID --query DBClusters[0].AssociatedRoles

4. Set up test table that will be exported to s3
------------------------------------------------

* Launch psql with appropriate environment vars
psql --set=TEST_BUCKET="$TEST_BUCKET"  --set=AWS_DEFAULT_REGION="$AWS_DEFAULT_REGION"

* Create a test table
=> CREATE TABLE extension_test AS 
SELECT s, md5(random()::text) 
FROM generate_Series(1,5) s;

5. Enable the extension
-----------------------
=> CREATE EXTENSION IF NOT EXISTS aws_s3 CASCADE;

6. Specify S3 path to export to. This command will setup the env variable s3_uri_1
----------------------------------------------------------------------------------

=> SELECT aws_commons.create_s3_uri( 
   :'TEST_BUCKET' ,   
   'exported_data.txt', 
   :'AWS_DEFAULT_REGION' 
) AS s3_uri_1 \gset  

(Optional)
=> SELECT :'s3_uri_1' AS s3_uri ;

7. Export the data to S3
------------------------
=> SELECT * FROM aws_s3.query_export_to_s3('SELECT * FROM extension_test', 
   :'s3_uri_1',
   options :='format csv'
);

8. Check out the exported data
------------------------------

* Quit the psql

aws s3 ls "s3://$TEST_BUCKET"

* This will print the content of th efile
sudo aws s3 cp "s3://$TEST_BUCKET/exported_data.txt" /dev/stdout   --quiet


Clean up (Recipe: aws_s3)
=========================
Now we need to cleanup the environment

1. Remove the role association from the DB cluster
aws  rds      remove-role-from-db-cluster  \
                --db-cluster-identifier     $PG_CLUSTER_ID   \
                --role-arn                  $TEST_ROLE_ARN   \
                --feature-name              s3Export  

* Check the status of this change
* The status may be *Pending* for some time. Wait till the role is disassociated

aws rds describe-db-clusters  --db-cluster-id $PG_CLUSTER_ID --query DBClusters[0].AssociatedRoles

2. Drop the extension

psql --set=TEST_BUCKET="$TEST_BUCKET"  --set=AWS_DEFAULT_REGION="$AWS_DEFAULT_REGION"

=> DROP EXTENSION aws_s3 ;

3. Delete the content of the bucket
aws s3 rm s3://$TEST_BUCKET --recursive

3. Delete the Cloud Formation stack
Go to console and delete the stack

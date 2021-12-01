========================
Using IAM Authentication
========================

1. Enable the IAM authentication
--------------------------------
    * May be done at the time of cluster creation
    * Cluster may be modified to support it

2. Create a PostgreSQL Role
---------------------------
    * Grant special permission to role 
    * Grant the permissions to the role
    * Login to psql as masteruser
=> CREATE ROLE iam_dbuser WITH LOGIN;
=> GRANT rds_iam TO iam_dbuser
=> \du

3. Create an IAM Role for iam_dbuser
------------------------------------
    * Allow IAM role to connect with the DB cluster using iam_dbuser
    * Create a policy that allows the action {rds-db:connect} for the DB user resource
    * Attaches the policy to the ROLE 

$ cd security/iam
$ chmod u+x *.sh

$ ./setup-iam-role.sh   <<Provide account number>>   <<DB Cluster Resource ID>>

* If successful the policy and role will be created

4. Bastion host assumes the role : rdsa-iam-dbuser-role
-------------------------------------------------------
* Run the script to assume the role
* Script sets up the environment variables [AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN]

$ source   ./assume-dbuser-role.sh

5. Get DB Auth token and use it as psql password
------------------------------------------------
* We will start a psql session as iam_dbuser

$  export PGPASSWORD_IAM_USER="$(aws rds generate-db-auth-token \
--hostname $PGHOST \
--port 5432 \
--region $AWS_DEFAULT_REGION \
--username iam_dbuser)"

$  PGPASSWORD=$PGPASSWORD_IAM_USER psql -U iam_dbuser

=> \conninfo

* You may try out SQL statements
* Attempt to create DB will fail as iam_dbuser does not have the permission

Cleanup
-------

* Session cleanup
$ unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
$ aws sts get-caller-identity

* IAM Cleanup
$ ./cleanup-iam.sh

* DB Cleanup
$ psql  -c "DROP ROLE iam_dbuser"

* Modify instance to disable IAM Authentication












Connect pgAdmin using IAM 
-------------------------
https://aws.amazon.com/blogs/database/using-iam-authentication-to-connect-with-pgadmin-amazon-aurora-postgresql-or-amazon-rds-for-postgresql/

============
CLI Commands
============

Using the CLI to create a policy
--------------------------------
https://docs.aws.amazon.com/cli/latest/reference/iam/create-policy.html


Delete the policy
-----------------
aws iam delete-policy --policy-arn arn:aws:iam::123456789012:policy/rdsa-iam-dbuser-policy


Using the CLI to assume a role
------------------------------
https://aws.amazon.com/premiumsupport/knowledge-center/iam-assume-role-cli/


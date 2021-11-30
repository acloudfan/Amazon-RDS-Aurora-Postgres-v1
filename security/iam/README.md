========================
Using IAM Authentication
========================
1. Enable the IAM authentication
    * May be done at the time of cluster creation
    * Cluster may be modified to support it
2. Create a PostgreSQL Role
    * Grant special permission to role 
    * Grant the permissions to the role

=> CREATE ROLE iam_dbuser WITH LOGIN;
=> GRANT rds_iam TO iam_dbuser

3. Requires creation of an IAM policy 
    * Allows IAM user to connect with the DB cluster using IAM DB auth
    * Policy allows the action   rds-db:connect for the DB user resource
    * Attaches to a ROLE in PostgreSQL database [iamuser_role]



4. Attach the IAM policy to the IAM user/role

aws sts assume-role --role-arn <<Copy paste role arn>>  --role-session-name AWSCLI-Session

aws sts get-caller-identity
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN




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


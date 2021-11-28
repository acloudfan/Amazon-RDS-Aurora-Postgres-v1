# Security related tasks



==============
Enforce SSL
==============
PGSSLMODE=require PGSSLROOTCERT=/fullpath/rds-ca-2019-root.pem psql -h $PGHOST -U masteruser -d labdb


PGSSLMODE=require PGSSLROOTCERT=/fullpath/rds-ca-2019-root.pem psql -h $PGHOST -U $PGHOST -d $PGDATABASE

Cross Account Cloning
=====================
https://aws.amazon.com/about-aws/whats-new/2019/07/amazon_aurora_supportscloningacrossawsaccounts-/

https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Managing.Clone.html#Aurora.Managing.Clone.Cross-Account


Cloning limitation
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Managing.Clone.html#Aurora.Managing.Clone.Limitations

1. Create a CMK
* Add the other account's root as the user

2. Setup the VPC
* CF for VPC
* Setup the subnet group

3. Create the DB Cluster

4. Go to RAM and setup a share with the specified account
* Sharing can also be initiated from the RDS console

5. Other account receives the invite and it needs to be accepted

6. In the account#2 the shared DB will appear in the list of database
Role = "Shared from account #111111111111"
* Select it and create a clone
* Creates an instance
* Setup the encryption 
    - new CMK
    - Default RDS key
    - Use the CMK shared by Account#1


https://medium.com/@pratheekhegde/lamda-function-for-automated-manual-rds-snapshots-d84e1d002019
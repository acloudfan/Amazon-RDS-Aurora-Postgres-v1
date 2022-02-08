

=================================
Clone a cluster within an Account
MOVE TO CLUSTER MANAGEMENT - UPDATE Video
=================================

1. Create the clone using RDS console
-------------------------------------
* Select the cluster
* Select Actions>>Create Clone
* Set the name = rdsa-postgresql-clone
* Leave everything else as default and create

2. Setup bastion host environment for clone
-------------------------------------------
* Open a Bastion terminal
* Use the script to set up environment variables for connecting to clone

source  ./bin/db/setup-clone-env.sh

3. Confirm that you are connecting to clone
-------------------------------------------
* Verify if writer EP is pointing to the node in the cloned cluster

dig $WRITEREP  +short

4. Create a table & insert some rows
------------------------------------
psql -c "CREATE table only_in_clone(id int);"
psql -c "INSERT INTO only_in_clone VALUES(100);"

5. SELECT from table on source cluster
--------------------------------------
* Open a new Bastion Host session
* Confirm you are connecting to the cluster : rdsa-postgresql-cluster
* Run the select statement

psql -c "SELECT * FROM only_in_clone;"

* You will get an error as the table is NOT available in the source cluster DB

Cleanup
-------
* Delete the Clone cluster




=====================
Cross Account Cloning
MOVE TO CLUSTER MANAGEMENT - UPDATE Video
=====================


===========
References:
===========

Aurora Metrics 
--------------
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.AuroraMySQL.Monitoring.Metrics.html

Aurora Pricing
--------------
https://aws.amazon.com/rds/aurora/pricing/

Local Storage Issues
--------------------
https://aws.amazon.com/premiumsupport/knowledge-center/postgresql-aurora-storage-issue/



=====================
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
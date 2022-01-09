===============================
Check the storage volume status
===============================
* Run the SQL in psql
* Data is stributed across a set of nodes
SELECT * FROM aurora_show_volume_status();


===========================================
Vertical Scaling : Modify the Instance type
===========================================

Test setup: 
1. Single instance cluster: 
    * Cluster will become unavailable during modification

2. Cluster with at least 1 replica: Fails over
    * You may create a replica to try out this scenario

    ./bin/db/create-replica.sh node-02

1. Get the supported instance type
-----------------------------------
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.DBInstanceClass.html

# Get the instance availability
PG_VERSION=$(psql -t -c "SHOW server_version" )

# Get the instance types in region for the PG version in use
aws rds describe-orderable-db-instance-options --engine aurora-postgresql \
    --query "OrderableDBInstanceOptions[].{DBInstanceClass:DBInstanceClass,SupportedEngineModes:SupportedEngineModes[0]}" \
    --output table --engine-version $PG_VERSION   \
    --region $AWS_DEFAULT_REGION



2. Modify the instance using CLI
--------------------------------
* Applies the modification immediately instead of waiting for the maintenance window

# Modify the instance
# 1. Update the instance rdsa-node-01 
# 2. Provide instance class
# 3. Apply the change immediately

./bin/db/modify-db-cluster-instance.sh   \
    rdsa-postgresql-node-01 \
    db.r5.large    \
    --apply-immediately

3. Track the failover
---------------------
* Script checks the IP address for READER/WRITER instance every 5 seconds
* Prints a change in Writer EP & Reader EP

# Track the change in WRITER/READER Endpoints

./bin/db/dbcluster-dig.sh


Cleanup
-------
1. Delete the Replica

* Delete will fail if the cluster is in stopped state.

./bin/db/delete-replica.sh    node-02

2. Scale down the DB instance for node-01

* There will be an outage 

./bin/db/modify-db-cluster-instance.sh   \
    rdsa-postgresql-node-01 \
    db.t3.medium    \
    --apply-immediately

* Optionally run the script to see a change in Endpoints

./bin/db/dbcluster-dig.sh

* Optionally try to run psql and you would get an error indicating that DB is unavailable while the instance is getting modified


=================================
Horizontal Scaling : Auto Scaling
=================================

Exercise setup
--------------
* We will be using pgbench in this exercise so ensure you have the DB pgbenchtest

# Create the pgbench database
psql -c "CREATE DATABASE pgbenchtest;"

# Initialize the pgbench database
pgbench -i  pgbenchtest

* Since Auto scaling requires at least 1 Replica, create if you have none

./bin/db/create-replica.sh node-02


1. Setup Policy
---------------
* RDS Console >> Select the cluster
* Click on the tab  'Logs & Events'
* Click on the button 'Add auto scaling policy'
    - Policy name = rdsa-auto-scaling-policy
    - Target metrics : 'Average connections to Aurora Replicas'
    - Target value = 50

* Click on 'Additional configuration'
  NOTE: 10 seconds is too short - only for testing
        Set it to a couple of minutes based on workload pattern
    - Scale in cooldown : 10 seconds
    - Scale out cooldown : 10 seconds
* Set the 'Cluster capacity details'
    - Min capacity = 1
    - Max capacity = 2

2. Bash Terminal#1  Run a load test with 40 connections
-------------------------------------------------------
* This will continuously run the load against the Reader EP

* Create 40 connections
pgbench -h $PGREADEREP -n -c 40    -T 900 -P 5 -b select-only -r  pgbenchtest

3. Bash Terminal#2  Run a load test with 15
-------------------------------------------
* This will lead to creation of an additiona REPLICA

pgbench -h $PGREADEREP -n -c 15    -T 900 -P 5 -b select-only -r  pgbenchtest

* In RDS console check status under 
  "Logs & events" >> "Auto scaling activities"

    "Event: Adding 1 read replica(s)."

* After a couple of minutes you will see an additional Replica in the cluster

4. Kill the pgbench test on both terminals  using ^C
----------------------------------------------------


5. Observe the scale down in RDS Console
----------------------------------------

* Under the "Logs & events" >> "Auto scaling activities"

    "Removing 1 read replica(s)."

* After a couple of minutes the new Replica instance will be deleted


Cleanup
-------

* Delete the Auto Scaling Policy
* Delete all Replicas
* Stop the cluster & Bastion host if you won't be using it for a while


==================================
Part-1 : Failover with RDS Console
==================================

Exercise setup
--------------
* In this set up we will need 2 Replicas with different priorities


* Create replica node-02 (skip if you already have it)

./bin/db/create-replica.sh node-02

1. Checkout the READER & WRITER endpoints
------------------------------------------
* On Bastion host
dig $PGWRITEREP | grep node-  <<This will point to node-01>>
dig $PGREADEREP | grep node-  <<This will point to node-02>>

2. Trigger Failover on console
-------------------------------
* Select any instance in RDS/Cluster
* Initiate failover by Actions>>Failover

3. Check the WRITER & READER endpoints
--------------------------------------
* On Bastion host
dig $PGWRITEREP | grep node-  <<This will point to node-02>>

dig $PGREADEREP | grep node-  <<This will point to node-01>>

===============================
Part-2 : Failover with priority
===============================

Exercise setup
--------------
* In this set up we will need 2 Replicas with different priorities


* Create replica node-02 (skip if you already have it)

./bin/db/create-replica.sh node-02

* Create replica node-03 (skip if you already have it)

./bin/db/create-replica.sh node-03

1. Modify the node-03 priority tier using console
-------------------------------------------------
* Select the node-03 in RDS console
* Click on modify
* Change the priority to 'tier-2'
* Check 'Apply Immediately'
* Modify

2. Verify priority change in the RDS console
--------------------------------------------

3. Trigger a failover
---------------------
* Use the Bastion host to trigger failover

aws rds failover-db-cluster --db-cluster-identifier rdsa-postgresql-cluster 

4. Observe in RDS console
-------------------------
* Node-1 should become WRITER after the failover


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


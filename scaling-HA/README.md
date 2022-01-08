===============================
Check the storage volume status
===============================
* Run the SQL in psql
* Data is stributed across a set of nodes
SELECT * FROM aurora_show_volume_status();


========================
Modify the Instance type
========================

1. Get the supported instance type
-----------------------------------
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.DBInstanceClass.html

# Get the instance availability
PG_VERSION=$(psql -t -c "SHOW server_version" )

aws rds describe-orderable-db-instance-options --engine aurora-postgresql \
    --query "OrderableDBInstanceOptions[].{DBInstanceClass:DBInstanceClass,SupportedEngineModes:SupportedEngineModes[0]}" \
    --output table --engine-version $PG_VERSION   \
    --region $AWS_DEFAULT_REGION



2. Modify the instance using CLI
--------------------------------
* Applies the modification immediately instead of waiting for the maintenance window
./bin/db/modify-db-cluster-instance.sh   rdsa-node-01  INSTANCE_CLASS   --apply-immediately

3. Track the failover
---------------------
* Script checks the IP address for READER/WRITER instance every 5 seconds
* Prints a change in Writer EP & Reader EP

./bin/db/dbcluster-dig.sh

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


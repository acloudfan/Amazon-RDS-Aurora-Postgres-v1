postgres-cluster-replica.yml
============================
Creates a READ Replica for the Aurora cluster
There are 2 roles of the replica
- offload reads from master server to improve its performance
- takes up role of primary in case of a failover

Lab : Setup a READ Replica
==========================
1. Create a replica using the Cloud Formation templte
CF Stack name = rdsa-postgresql-node-02
Node name =  rdsa-postgresql-node-02

2. Checkout the endpoints
dig $PGWRITEREP   <<This will point to node-01>>
dig $PGREADEREP   <<This will point to node-02>>

3. Run a WRITE query against the READ replica
E.g., DROP TABLE test;  this will throw an error

4. Execute the following psql to get the replication status



==================================
Check the status of the Replica(s)
==================================
* Information accessed using the function aurora_replica_status()

* Simple query - doesn't tell if its master or replica
SELECT server_id, replica_lag_in_msec,is_current  
FROM aurora_replica_status();

* Query differentiates between master/standby
SELECT server_id, 
    CASE 
        WHEN session_id= 'MASTER_SESSION_ID' 
        THEN 'Writer' 
        ELSE 'Reader' 
    END AS Role, 
    replica_lag_in_msec as AuroraReplicaLag 
FROM aurora_replica_status();

=================================
Replica Failure - Fault injection
=================================
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraPostgreSQL.Managing.FaultInjectionQueries.html


* Simulate failure for 20 seconds
SELECT aurora_inject_replica_failure(
   100, 
   20, 
   'rdsa-postgresql-node-02'
);

* Simulate failure for 2 minutes
SELECT aurora_inject_replica_failure(
   100, 
   120, 
   'rdsa-postgresql-node-02'
);



Exercise (Part-1) : Checkout Failover
============================
1. Make sure the DB cluster is up with a Primary & Replica instance
2. Checkout the READER & WRITER endpoints
dig $PGWRITEREP   <<This will point to node-02>>
dig $PGREADEREP   <<This will point to node-01>>
3. Using the console or CLI execute the failover
4. Check the WRITER & READER endpoints
- The WRITER EP should point to node-02
- The READER EP should point to node-01


Exercise (Part-2) : Checkout Failover Priorities
================================================
Assumption: Previous exercise was conducted and node-02 is primary
1. Setup additional instance of Replica  (node-03) using CF Template : postgres-cluster-replica.yml
- DB Cluster = rdsa-postgresql-cluster
- Stack name = rdsa-postgresql-node-03
- Replica node name = rdsa-postgresql-node-03
2. Change failover priority for node-03 to tier-2 
- node-01 has default failover priority of tier-1
- apply immediately
- wait for a few minutes and ensure node-03 stack is created
3. Execute failover - which node will become primary?
- Failover takes roughly a minute
4. Try out other priority assignments


Failover using AWS CLI
======================
aws rds failover-db-cluster --db-cluster-identifier rdsa-postgresql-cluster 
Can work only if there are > 1 instances


=============
pgbench Error
=============
"pgbench: error: empty range given to random"

* This indicates a consistency error in the database 'pgbenchtest'
* Typically happens when the pgbench initialization is aborted
* To resolve:
  1. DROP DATABASE pgbenchtest
  2. CREATE DATABASE pgbenchtest
  3. Initialize pgbench
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
dig $PGREADEREP   <<This will pount to node-02>>

3. Run a WRITE query against the READ replica
E.g., DROP TABLE test;  this will throw an error

4. Execute the following psql to get the replication status

select server_id, replica_lag_in_msec,is_current  from aurora_replica_status();







Failover using AWS CI
=====================
aws rds failover-db-cluster --db-cluster-identifier rdsa-postgresql-cluster 
Can work only if there are > 1 instances
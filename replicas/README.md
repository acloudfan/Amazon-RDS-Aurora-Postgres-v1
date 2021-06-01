postgres-cluster-replica.yml
============================
Creates a READ Replica for the Aurora cluster
There are 2 roles of the replica
- offload reads from master server to improve its performance
- takes up role of primary in case of a failover


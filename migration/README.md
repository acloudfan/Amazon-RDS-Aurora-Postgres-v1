# Demonstrates the use of tools that can assist with the migration of db




Note:
* If the DMS replication instance is in a different VPC then peering would be needed?

* If the DMS replication instance is in the same VPC as RDS then SG MUST be adjusted to ensure that DMS replication instance is able to connect to the RDS. This is needed even with the the above?



Links:
- Troubleshoot DMS errors
https://aws.amazon.com/premiumsupport/knowledge-center/dms-task-error-status/

- Link for downloading the PostgreSQL JDBC driver
https://jdbc.postgresql.org/download.html


============


============
Auto scaling
============
* Setup a scaling policy
    - Target metrics : DB Connections
    - Cooldown : 10 seconds
    - Min = 1, Max =2
* Run a load test against the Reader for 15 minutes
pgbench -h $PGREADEREP  -c 70 -j 2 -n   -M prepared   -T 900 -P 5 -b select-only -r  pgbenchtest


===============================
enhanced-monitoring-sample.json
===============================
This is a sample JSON for a log record published by RDS/EM to CloudWatch. Refer to the link below for the details of each metric:
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_Monitoring.OS.CloudWatchLogs.html

For viewing the JSON you may use the viewer: http://jsonviewer.stack.hu/


Recipe: RDS Event Retention in CloudWatch
=========================================
1. Setup a CloudWatch Log Group
/aws/events/RDSAllEvents
Set the retention on log group = 6 months

2. Set up a rule on Event Bridge
* Name = All-RDS-Events
* Service Name = RDS
* Event Type = All 
* Add Target = CloudWatch group created in #1

3. Take some action on RDS cluster & check events in CloudWatch
* E.g., reboot instance
* E.g., take snapshot




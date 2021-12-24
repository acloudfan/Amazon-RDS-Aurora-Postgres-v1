#!/bin/bash
# Stops the DB cluster and the Bastion host

# Stop the DB Cluster
~/bin/db/dbcluster.sh stop

# Stop the Linux host
~/bin/host/stop-host.sh linux


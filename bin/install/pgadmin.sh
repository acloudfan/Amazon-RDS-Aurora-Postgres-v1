#!/bin/bash
# Setup PgAdmin on the bastion host


#1. Pull the image for PgAdmin4
docker pull dpage/pgadmin4

#2. Setup directory for PgAdmin

# if folder does not exist then create
sudo mkdir /var/lib/pgadmin
sudo chown 5050:5050 /var/lib/pgadmin

#3. Echo message for start | stop PgAdmin4
echo "Installation Done."
echo "To start PgAdmin -  ./bin/startadmin"
echo "To Stop  PgAdmin -  ./bin/stopadmin"

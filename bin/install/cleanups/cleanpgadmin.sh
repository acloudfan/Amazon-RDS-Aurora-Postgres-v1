#!/bin/bash
#Cleanup the /var/lib/pgadmin

# Delete folder
sudo rmdir /var/lib/pgadmin/

# Create the folder
sudo mkdir /var/lib/pgadmin
sudo chown 5050:5050 /var/lib/pgadmin

echo "Done"

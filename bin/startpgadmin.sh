#!/bin/bash
# Starts the PG Admin docker container

PGADMIN_EMAIL=admin@abc.com
PGADMIN_PASSWORD=passw0rd

PGADMIN_CONTAINER_NAME=pgadmincontainer

#1. Run Docker container
docker run   -d  --name $PGADMIN_CONTAINER_NAME \
            -e PGADMIN_DEFAULT_EMAIL="$PGADMIN_EMAIL" \
            -e PGADMIN_DEFAULT_PASSWORD="$PGADMIN_PASSWORD"  \
            -p 0.0.0.0:8080:80/tcp          \
            -v /var/lib/pgadmin:/var/lib/pgadmin dpage/pgadmin4:latest 
               
            

#2. Echo URL for accessing PgAdmin
IPV4=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

echo "======================="
echo "URL:  http://$IPV4:8080"
echo "======================="

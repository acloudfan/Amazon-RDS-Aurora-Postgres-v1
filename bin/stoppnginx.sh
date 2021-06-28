#!/bin/bash
#Stop the nginx container
NGINX_CONTAINER_NAME=nginx

if [ $(docker inspect -f '{{.State.Running}}' $CONTAINER_NAME) = "true" ]; then 
    docker kill 
else 
    echo "nginx is NOT running !!!"
fi
#!/bin/bash
#Starts the nginx server to serve the reports

NGINX_CONTAINER_NAME=nginx

#1. 
if [ $(docker inspect -f '{{.State.Running}}' $CONTAINER_NAME) = "true" ]; then 
    echo "nginx is already running !!!"
else 
    docker run -d -it --rm  --name $NGINX_CONTAINER_NAME -p 8082:80 \
            -v ~/nginx/html:/usr/share/nginx/html \
            -v ~/nginx/nginx-cache:/var/cache/nginx \
            -v ~/nginx/nginx-pid:/var/run  \
            -v ~/nginx/nginx.conf:/etc/nginx/nginx.conf:ro  nginx 
fi

#2. Launches the nginx container
IPV4=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

echo "================================="
echo "URL:  http://$IPV4:8082"
echo "================================="
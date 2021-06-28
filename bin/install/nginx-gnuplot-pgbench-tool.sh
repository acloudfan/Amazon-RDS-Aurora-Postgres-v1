#!/bin/bash
#Installs Nginx docker container/config on the host

#1. Create the folders
mkdir -p ~/nginx/html
mkdir -p ~/nginx/nginx-cache
mkdir -p ~/nginx/nginx-pid
mkdir -p ~/nginx/pgbench-tools

#2. Pull the container image
docker pull nginx:latest

#3. Setup the configuration
cp misc/nginx.conf  ~/nginx/nginx.conf

#4. Set up gnuplot
sudo yum install gnuplot -y

#5. Clone the pgbench-tools
git clone https://github.com/acloudfan/pgbench-tools.git

#6. Steps for setting up the pgbench-tools

#6.1 Create the results database
psql -c 'CREATE DATABASE  pgbenchtools'

#6.2 Setup the results database
psql -f ~/pgbench-tools/init/resultdb.sql -d pgbenchtools


#!/bin/bash

PGADMIN_CONTAINER_NAME=pgadmincontainer

docker kill $PGADMIN_CONTAINER_NAME
docker rm $PGADMIN_CONTAINER_NAME
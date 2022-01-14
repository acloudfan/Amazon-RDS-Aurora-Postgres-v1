#!/bin/bash
#Deletes the custom DB Parameter group

#!/bin/bash
#Script creates the DB parameter group for the given DB family
#https://docs.aws.amazon.com/cli/latest/reference/rds/create-db-parameter-group.html
# Usage:  ./bin/bash/create-custom-db-pg.sh  <Name>  '<Description>'

if [ -z "$1" ]; then
    echo "Usage:  ./bin/bash/delete-custom-db-cluster-pg.sh  <Name>"
    echo "Please provide the Name !!"
    exit
fi

DBPG_NAME=$1
DBPG_DESC=$2

aws rds delete-db-cluster-parameter-group   \
    --db-cluster-parameter-group-name       "$DBPG_NAME"  


echo "Done."
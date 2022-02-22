#!/bin/bash
#https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_UpgradeDBInstance.PostgreSQL.html
#Gets the major versions available for upgrade
#Usage: ./bin/db/check-upgrade-version.sh  <<current PG version>>


if [ -z "$1" ]; then
    echo "Usage:  ./bin/db/check-upgrade-version.sh  <<current PG version>>"
    echo "Please provide the version e.g., 10.11 !!"
    exit
else
    DB_VERSION=$1
fi

# Get the versions
aws rds describe-db-engine-versions \
  --engine aurora-postgresql \
  --engine-version $DB_VERSION  \
  --query 'DBEngineVersions[].ValidUpgradeTarget[?IsMajorVersionUpgrade == `true`].{EngineVersion:EngineVersion}' \
  --output text


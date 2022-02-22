# Cluster Maintenance

# Get the major versions available for upgrade
# https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_UpgradeDBInstance.PostgreSQL.html

./bin/db/check-upgrade-version.sh  <<current PG version>>

Example: ./bin/db/check-upgrade-version.sh  10.11


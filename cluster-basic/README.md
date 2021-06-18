YML
===
security-group.yml            Creates the SG for the DB cluster instances
postgres-cluster.yml          Creates the Aurora cluster with 1 instance
enhanced-monitoring-role.yml  Creates the role for EM



security-group.yml
==================
Sets up the security group for Aurora cluster

postgres-cluster.yml
====================
+ Creates the DB Subnet group
+ Create the DB Cluster
+ Creates the DB Instance (primary node)

Bastion host
============
EC2 instance needs a role for aws cli

1. Create the VPC
2. Create the security group
3. Create the DB cluster

Enhanced Monitoring Role
========================
Stack Name: rdsa-postgresql-enhanced-monitoring-role
The role created is used for manually enabling the Enhanced monitoring on DB instance(s)

Login as ec2-user using System Manager connect
==============================================
sudo su -
su ec2-user
cd







psql:
====
https://dailyscrawl.com/how-to-install-postgresql-on-amazon-linux-2/
https://techviewleo.com/install-postgresql-12-on-amazon-linux/
sudo su -
amazon-linux-extras install postgresql10 vim epel
yum install -y postgresql-server postgresql-devel

amazon-linux-extras install postgresql11 vim epel -y

pgbench
=======
yum install postgresql-contrib

jq
==
sudo yum install -y jq

pg-admin
========

1. Install Docker
https://gist.github.com/npearce/6f3c7826c7499587f00957fee62f8ee9

sudo amazon-linux-extras install docker

sudo amazon-linux-extras install docker
sudo service docker start
sudo usermod -a -G docker ec2-user
Make docker auto-start

sudo chkconfig docker on

Because you always need it....

sudo yum install -y git

Reboot to verify it all loads fine on its own.

sudo reboot

1. Install the container image
https://www.pgadmin.org/docs/pgadmin4/latest/container_deployment.html

docker pull dpage/pgadmin4

2. Run the container
sudo mkdir /var/lib/pgadmin
sudo chown 5050:5050 /var/lib/pgadmin
docker run  -e PGADMIN_DEFAULT_EMAIL=xyz@abc.com -e PGADMIN_DEFAULT_PASSWORD=rid  -p 0.0.0.0:8080:80/tcp  -v /var/lib/pgadmin:/var/lib/pgadmin dpage/pgadmin4:latest



test
====

psql -h  rdsa-postgresql-custer-cluster.cluster-ckaskuynouaf.us-east-1.rds.amazonaws.com -p 5432 -U masteruser -d labdb

psql -h  $PGHOST -p 5432 -U masteruser -d labdb

Pgbench
========


pgbench -i --fillfactor=10 --scale=100 $PGDATABASE -h $PGHOST -U $PGUSER 

pgbench --progress-timestamp -M prepared -n -T 300 -P 5 -c 50 -j 50  -b select-only@20 -h $PGHOST -U $PGUSER  $PGDATABASE 


pgbench --progress-timestamp -M prepared -n -T 120 -P 5 -c 50 -j 50  -b tpcb-like@1 -h "$PGHOST" -U $PGUSER  $PGDATABASE 

pgbench --progress-timestamp -M prepared -n -T 60 -P 5 -c 50 -j 50 -b tpcb-like@1 -b select-only@20 -h $PGHOST -U $PGUSER  $PGDATABASE 


Environment
===========
export PGHOST=<cluster end point>
export PGPORT=5432
export PGUSER=masteruser
export PGPASSWORD=masteruserpw
export PGDATABASE=labdb

export PGWRITEREP="$(aws rds describe-db-clusters --region us-east-1 --db-cluster-identifier rdsa-postgresql-cluster | jq -r .DBClusters[0].Endpoint)"

export PGREADEREP=$(aws rds describe-db-clusters --region us-east-1 --db-cluster-identifier rdsa-postgresql-cluster | jq -r .DBClusters[0].ReaderEndpoint)

export PGHOST=$PGWRITEREP

export PGHOST=$PGREADEREP

HammerDB
========
https://www.hammerdb.com/blog/uncategorized/using-hammerdb-as-a-web-service/


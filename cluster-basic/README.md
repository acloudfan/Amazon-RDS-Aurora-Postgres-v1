Changes:
========
March 2024, Added newer versions of the PG
March 2024, Made v15.3 as the default


=======================
Create the test cluster
=======================
* Videos  in section#4 shows how to create the cluster with console
* The instructions here uses a combination of console & CLI

1. Create the VPC
-----------------
* AWS CloudFormation Console
* Create Stack >> With new resources
* YML = vpc/cluster-vpc-2-az.yml
    -   Stack Name=rdsa-vpc

2. Create the Bastion Host
--------------------------
* AWS CloudFormation Console
* Create Stack >> With new resources
* YML = vpc/bastion-host.yml
    -   Stack Name=rdsa-bastion-host
    -   Subnet=<<Select rdsa PublicSubnet>>
    -   VpcId=<<Select rdsa VPC>>

3. Setup the Bastion host
-------------------------
* You may use the CloudFormation console
* Log onto the Bastion host
  Click on link to host in the Cloudformation>>rdsa-bastion-host>>Resources


curl https://raw.githubusercontent.com/acloudfan/Amazon-RDS-Aurora-Postgres-v1/master/bin/install/setup-bastion.sh --output setup-bastion-host.sh 

* Change mod of the file
$ chmod u+x ./setup-bastion-host.sh 

* Setup the environment
$ ./setup-bastion-host.sh <<Provide AWS  Region>>  

* Log out and log back in 

$ env | grep PG
* NOTE: Some env vars will be empty as the Aurora PG cluster is not yet created

4. Create the security group
----------------------------
* You may do it using the CloudFormation console
* YML = basic-cluster/postgres-cluster.yml
  Stack name = security-group.yml

* Or on Bastion host use the script:
$ ./bin/db/create-security-group-internal.sh


5. Create the Aurora PG Cluster
-------------------------------
* You may do it using the CloudFormation console
* YML = basic-cluster/postgres-cluster.yml
  Stack name = rdsa-postgresql
  PrivateSubnets = <<Copy paste from rdsa-vpc stack - Output parameters>>

* Or on Bastion host use the script. It creates the subnet group & DB cluster:
$  ./bin/db/create-dbcluster-cf-stack.sh

* Wait for the DB cluster to become available

6. Update the Bastion host environment
--------------------------------------
* Update the bastion host environment

$ ./bin/install/setup-bastion.sh    <<AWS Region>>

* Log out and log back in

7. Test out the cluster
-----------------------
* Check status

$ ./bin/db/dbcluster.sh  status

* Launch psql for testing

$ psql 

=> CREATE TABLE test (id int);

=> INSERT INTO test VALUES(1);

=> SELECT * FROM test;

============
Stop cluster & Bation host
============

$ ./bin/db  dbcluster.sh  stop


YML
===
enhanced-monitoring-role.yml  Creates the role for EM

security-group.yml
==================
Sets up the security group for Aurora cluster

security-group.yml            Creates the SG for the DB cluster instances
Stack name = rdsa-security-group

postgres-cluster.yml
====================
Pre-Requisiste: Must create the security group used for the DB instances
The cloudformation template creates:
+ Creates the DB Subnet group
+ Create the DB Cluster
+ Creates the DB Instance (primary node)

postgres-cluster.yml          Creates the Aurora cluster with 1 instance
Stack name = rdsa-postgresql


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


Login as ec2-user using System Manager (SSM) connect
====================================================
sudo su - ec2-user



PgAdmin4
========
Installation:
1. Setup Docker
./bin/install/docker.sh

2. Setup PgAdmin4
./bin/install/pgadmin.sh

3. To start PgAdmin
./bin/startpgadmin.sh

4. To test use the link from startpgadmin.sh
Use Email = admin@abc.com
Password = passw0rd

5. To stop PgAdmin
./bin/stoppgadmin.sh

To add DB cluster to PgAdmin
============================
1. 


To Change pgadmin password
==========================
1. Stop PgAdmin       ./bin/stoppgadmin.sh
2. Cleanup PgAdmin    ./bin/install/cleanuppgadmin.sh
3. Edit the email/password in /bin/startpgadmin.sh
4. Start PgAdmin      ./bin/startpgadmin.sh




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


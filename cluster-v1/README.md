
security-group.yml
==================
Sets up the security group for Aurora cluster




Bastian host
============
- Private EC2 instance needs role for aws cli

psql:
====
https://dailyscrawl.com/how-to-install-postgresql-on-amazon-linux-2/
sudo su -
amazon-linux-extras install postgresql10 vim epel
yum install -y postgresql-server postgresql-devel

jq
==
sudo yum install -y jq

test
====

psql -h  rdsa-postgresql-custer-cluster.cluster-ckaskuynouaf.us-east-1.rds.amazonaws.com -p 5432 -U masteruser -d labdb
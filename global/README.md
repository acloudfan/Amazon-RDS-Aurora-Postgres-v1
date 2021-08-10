# Global Database

Create Global DB Clusing using the console
==========================================

### Setup the VPC & Bastion in us-west-1
1. Setup the VPC using CloudFormation
2. Setup the Bastion Host using CloudFormation
3. Setup the DB cluster using the CloudFormation

us-east-1
1. Create a new cluster in us-west-1
* Use the rdsa-vpc, SG, Subnet group etc
2. Create a VPC in us-west-2
* Use the CloudFormation
3. Add a region 
2. Add a region to the DB cluster
* us-east-1
3. 
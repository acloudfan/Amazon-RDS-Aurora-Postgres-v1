# Demostrates the use of TLS
# Client validates the identity of the RDS DB Server

* Log onto the EC2/Bastion
* Change folder to project root/security


1. Setup the psycopg2
---------------------
Sample code depends on this package. Run the commands to install it.

$ sudo yum install postgresql-devel
$ pip3 install psycopg2-binary

2. Run the sample
-----------------
Depends on the test table. Selects 5 rows from table & prints.

$ cd ~/Amazon-RDS-Aurora-Postgres-v1/security
$ python3  ./validate/sample.py

* Test will fail if the root.crt is not available under ~/.postgresql

3. Download and install the RDS CA certificate
-----------------------------------------------
* Create the folder
$ mkdir ~/.postgresql

* Copy the link for the certificate for the Region from the following link
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/UsingWithRDS.SSL.html

* Download the certificate (bundle pem)
$ wget <<Paste the link for the certificate>> -O ~/.postgresql/root.crt

4. Test the code again
----------------------
This time the code will work as the RDS certificates will be validated successfully

$ python3   ./validate/sample.py
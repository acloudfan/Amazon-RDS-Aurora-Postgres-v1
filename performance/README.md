========================
pg_buffercache
========================
https://www.postgresql.org/docs/12/pgbuffercache.html

Steps to setup and try out the extension.

=> CREATE EXTENSION pg_buffer_cache
=> SELECT n.nspname, c.relname, count(*) AS buffers
             FROM pg_buffercache b JOIN pg_class c
             ON b.relfilenode = pg_relation_filenode(c.oid) AND
                b.reldatabase IN (0, (SELECT oid FROM pg_database
                                      WHERE datname = current_database()))
             JOIN pg_namespace n ON n.oid = c.relnamespace
             GROUP BY n.nspname, c.relname
             ORDER BY 3 DESC
             LIMIT 10;
=> SELECT bufferid,
        CASE relforknumber
            WHEN 0 THEN 'main'
            WHEN 1 THEN 'fsm'
            WHEN 2 THEN 'vm'
        END relfork,
        relblocknumber,
        isdirty,
        usagecount,
        pinning_backends
        FROM pg_buffercache
        WHERE relfilenode = pg_relation_filenode('test'::regclass);





Initializing the pgbench
========================
1. Set up a test database
psql -c 'CREATE DATABASE pgbenchtest'

2. Initialize pgbnech tables
pgbench -i pgbenchtest

Running the test
================
https://www.postgresql.org/docs/11/pgbench.html

The following commands assume that a database with the name 'pgbenchtest' exists

* Initialize with 100x100,000 accounts, 100x1 branches, 100x10 tellers
pgbench -i -d --scale=100  pgbenchtest

* Run a test with 50 concurrent clients for specified duration of 120 seconds
pgbench -c 50 -j 2   -b  tpcb-like -M prepared   -T 120 -P 5  pgbenchtest

* Run a test with 100 concurrent clients to complete 1000 transactions each
pgbench -c 100 -j 2   -b  tpcb-like -M prepared   -t 1000 -P 5  pgbenchtest

* Run a test with 200 concurrent clients for 6 hours; report status every 30 minutes
pgbench -c 200  -b  tpcb-like -M prepared   -T 216000 -P 1800  pgbenchtest




pgbench-tool
============
1. Install gnuplot
sudo yum install gnuplot
https://riptutorial.com/gnuplot/example/11275/installation-or-setup

2. Clone repo
git clone https://github.com/acloudfan/pgbench-tools.git

3. Install nginx as app
sudo yum  update
sudo yum install nginx

Update listen port to 8080
sudo nano /etc/nginx/nginx.conf

3. Install nginx as a container
docker run -d -p 8082:80 --read-only -v $(pwd)/nginx-cache:/var/cache/nginx -v $(pwd)/nginx-pid:/var/run nginx

docker run -d -it --rm  --name nginx -p 8082:80 -v ~/nginx/html:/usr/share/nginx/html -v ~/nginx/nginx-cache:/var/cache/nginx -v ~/nginx/nginx-pid:/var/run  -v ~/nginx/nginx.conf:/etc/nginx/nginx.conf:ro  nginx

Python CGI for nginx
https://techexpert.tips/nginx/python-cgi-nginx/

4. Run the test using the script available in pgbench-tools (README.md)
setup the ./config 
Multiple vars to be updated with PG info
Report generated under /reports folder

5. Copy the generated webreport to /usr/share/nginx/html
All directories need to have 755 permission
All files need to have the 644 permission

Steup
=====
1. Create the database   'pgbenchtools'
2. Setup the relations
psql -f pgbench-tools/init/resultdb.sql -d pgbenchtools
3. Setup the pgbnech-tools/config
4. Create the testset
./bin/pgt/newset "db.t3.medium"
4. 
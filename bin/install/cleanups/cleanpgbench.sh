#!/bin/bash
#Cleanup the tables created by the pgbench tool

# If no argument provided tables are dropped in default database
# rop table if exists pgbench_accounts, pgbench_branches, pgbench_history, pgbench_tellers

psql -c "DROP TABLE IF EXISTS pgbench_accounts CASCADE" -d $1 

psql -c "DROP TABLE IF EXISTS pgbench_tellers CASCADE" -d $1 

psql -c "DROP TABLE IF EXISTS pgbench_history CASCADE" -d $1 

psql -c "DROP TABLE IF EXISTS pgbench_branches CASCADE" -d $1 

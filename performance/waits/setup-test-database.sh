#!/bin/sh
# Sets up the test database = pagila
# Pagila is a Postgres Sample database. 
# You may check it out here: https://github.com/devrimgunduz/pagila
# This script will setup the database on your Aurora cluster

# 1. Create a new database for testing
psql -c "DROP DATABASE IF EXISTS pagila "
psql -c "create database pagila"

# 2. Setup the extension in the database
psql -c "create extension pg_stat_statements" -d pagila

# 3. Create the tables, indexes etc
psql -f pagila-schema.sql  -d pagila

# 4. Populate the database with some test data
# Populate just the table : actor, category
psql -d pagila -f pagila-category-actor.sql  

# 5. Create functions that will be used from pgbench
psql -d pagila -f pagila-functions.sql


https://github.com/xzilla/pagila

INSTALLATION
------------

To install the pagila database, first create an empty database named pagila, and then feed in the schema file, followed by the data file. Using psql that would look like this:

psql -c "CREATE DATABASE pagila;"
psql -d pagila -f pagila-schema.sql
psql -d pagila -f pagila-data.sql

The pagila-data.sql file and the pagila-insert-data.sql both contain the same
data, the former using COPY commands, the latter using INSERT commands, so you 
only need to install one of them. Both formats are provided for those who have
trouble using one version or another.



https://www.datadoghq.com/blog/aws-rds-postgresql-monitoring/


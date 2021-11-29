# Install package otherwise erro = ModuleNotFoundError: No module named 'psycopg2'
# sudo yum install postgresql-devel
# pip3 install psycopg2-binary


import psycopg2
import os
import sys

USER = os.getenv('PGUSER')
PASSWORD = os.environ.get('PGPASSWORD')
DATABASE = os.environ.get('PGDATABASE')
HOST = os.environ.get('PGHOST')

# Check if a valid argument was provided. If not abort th execution of program.
if len(sys.argv) == 1:
    print("Error : Argument missing !!")
    print("        Valid values : disable, allow, prefer, require, verify-ca, verify-full")
    sys.exit()
else:
    SSL_MODE=sys.argv[1]

# Create the connection to the database
conn = psycopg2.connect(
    host= HOST,
    database = DATABASE,
    user = USER,
    password = PASSWORD,
    sslmode = SSL_MODE
)

# create a cursor
cur = conn.cursor()

cur.execute("SELECT * FROM test LIMIT 5")

rows = cur.fetchall()

for row in rows:
    print ("ID = ", row[0])

print ("Done.")

conn.close()

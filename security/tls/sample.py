# Install package otherwise import error
# pip3 install psycopg2

import psycopg2

USER = os.getenv('PGUSER')
PASSWORD = os.environ.get('PGPASSWORD')
DATABASE = os.environ.get('PGDATABASE')
HOST = os.environ.get('PGHOST')

# Create the connection to the database
conn = psycopg2.connect(
    host= HOST,
    database = DATABASE,
    user = USER,
    password = PASSWORD
)

# create a cursor
cur = conn.cursor()

cur.execute("SELECT * FROM test LIMIT 5")

rows = cur.fetchall()

for row in rows:
    print ("ID = ", row[0])

print ("Done.")

conn.close()

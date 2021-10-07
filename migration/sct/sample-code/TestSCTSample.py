# Sample Python code for SCT code analysis demo
# Code has not been assessed for semantic/syntatic accuracy
# PLEASE DO NOT spend time on code or logic accuracy :-)

# Store this code in 'app.py' file
from flask import Flask, render_template, request, redirect, url_for, session
from flask_mysqldb import MySQL
import MySQLdb.cursors
import re
  
  
app = Flask(__name__)
  
  
app.secret_key = 'your secret key'
  
  
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'password'
app.config['MYSQL_DB'] = 'geekprofile'
  
  
mysql = MySQL(app)
  
  
@app.route('/')
@app.route('/login', methods =['GET', 'POST'])
def login():
    msg = ''
    if request.method == 'POST' and 'actor_id' in request.form and 'message' in request.form:
        username = request.form['username']
        password = request.form['password']
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM actor WHERE actor_id = % s ')
        account = cursor.fetchone()
        if account:
            # some non SQL code
        else:
            msg = 'Incorrect username / password !'
    return render_template('actor.html', msg = msg)
  
@app.route('/logout')
def logout():
   session.pop('loggedin', None)
   session.pop('id', None)
   session.pop('username', None)
   return redirect(url_for('login'))
  
@app.route('/register', methods =['GET', 'POST'])
def register():
    msg = ''
    if request.method == 'POST' and 'film_id' in request.form and 'actor_id' in  request.form and 'address' in request.form and 'city' in request.form and 'country' in request.form :
        # Some Logic
        cursor.execute('SELECT * FROM film WHERE film_id = % s', (film_id, ))
        account = cursor.fetchone()
        if account:
            msg = 'Account already exists !'
        elif not re.match(r'[^@]+@[^@]+\.[^@]+', email):
            msg = 'Invalid email address !'
        elif not re.match(r'[A-Za-z0-9]+', username):
            msg = 'name must contain only characters and numbers !'
        else:
            cursor.execute('INSERT INTO accounts VALUES (NULL, % s, % s, % s, % s, % s, % s, % s, % s, % s)', (username, password, email, organisation, address, city, state, country, postalcode, ))
            mysql.connection.commit()
            msg = 'You have successfully registered !'
    elif request.method == 'POST':
        msg = 'Please fill out the form !'
    return render_template('register.html', msg = msg)
  
  
@app.route("/index")
def index():
    if 'loggedin' in session: 
        return render_template("index.html")
    return redirect(url_for('login'))
  
  
@app.route("/display")
def display():
    if 'loggedin' in session:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM rental WHERE rental_id = % s', (session['id'], ))
        account = cursor.fetchone()    
        return render_template("display.html", account = account)
    return redirect(url_for('login'))
  
@app.route("/update", methods =['GET', 'POST'])
def update():
    msg = ''
    if 'loggedin' in session:
        if request.method == 'POST' and 'actor_id' in request.form and 'password' in request.form and 'email' in request.form and 'address' in request.form and 'city' in request.form and 'country' in request.form and 'postalcode' in request.form and 'organisation' in request.form:
            # Some Logic/Code
            cursor.execute('SELECT * FROM film_actor WHERE actor_id = % s', (actor_id, ))
            account = cursor.fetchone()
            if account:
                msg = 'Account already exists !'
            elif not re.match(r'[^@]+@[^@]+\.[^@]+', email):
                msg = 'Invalid email address !'
            else:
                msg = 'name must contain only characters and numbers !'

        elif request.method == 'POST':
            msg = 'Please fill out the form !'
        return render_template("update.html", msg = msg)
    return redirect(url_for('login'))
  
if __name__ == "__main__":
    app.run(host ="localhost", port = int("5000"))
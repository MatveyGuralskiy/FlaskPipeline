# Flask Application with PostreSQL Database
import os
from flask import Flask, render_template, request, redirect, url_for, flash
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from dotenv import load_dotenv
from werkzeug.security import generate_password_hash, check_password_hash

# Load variables from .env file
load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv('SECRET_KEY')  # Load secret key from environment variable

# Configurations for connection to PostgreSQL
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
migrate = Migrate(app, db)

# Create User Table
CREATE_USERS_TABLE = """
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(80) UNIQUE NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    password_hash VARCHAR(128) NOT NULL
);
"""

with db.engine.connect() as connection:
    connection.execute(CREATE_USERS_TABLE)

# User model
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(128), nullable=False)

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

# Main Webpage
@app.route('/', methods=['GET', 'POST'])
def home():
    if request.method == 'POST':
        if request.form.get('action') == 'register':
            email = request.form['email']
            username = request.form['username']
            password = request.form['password']
            dob = request.form['dob']

            if User.query.filter((User.email == email) | (User.username == username)).first():
                flash('Email or Username already exists', 'error')
            else:
                new_user = User(email=email, username=username, dob=dob)
                new_user.set_password(password)
                db.session.add(new_user)
                db.session.commit()
                flash('Registration successful! Please log in.', 'success')

        elif request.form.get('action') == 'login':
            email_or_username = request.form['login-email-username']
            password = request.form['login-password']
            
            user = User.query.filter((User.email == email_or_username) | (User.username == email_or_username)).first()
            if user and user.check_password(password):
                flash('Welcome back!', 'success')
            else:
                flash('Incorrect email/username or password', 'error')

    return render_template('index.html')

# Webpage About
@app.route('/about')
def about():
    return render_template('about.html')

if __name__ == '__main__':
    app.run(debug=True)
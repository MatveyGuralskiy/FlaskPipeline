from flask import Flask, render_template, request, redirect, url_for, flash
from models import db, bcrypt, User
from flask_sqlalchemy import SQLAlchemy
from dotenv import load_dotenv
import os

# Load Environment Variables from .env
load_dotenv()

# Connect to Database
app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('SQLALCHEMY_DATABASE_URI')
db.init_app(app)

# Main Page
@app.route('/')
def index():
    return render_template('index.html')

# About Page
@app.route('/about')
def about():
    return render_template('about.html')

# Other Page
@app.route('/other')
def other():
    return render_template('other.html')

# Register Page
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']
        
        # Salt to password
        salt = os.urandom(16).hex()
        # Hashing function
        hashed_password = bcrypt.generate_password_hash(password + salt).decode('utf-8')
        
        new_user = User(username=username, email=email, password=hashed_password, salt=salt)
        db.session.add(new_user)
        db.session.commit()
        
        flash('Registration successful!', 'success')
        return redirect(url_for('index'))
    
    return render_template('register.html')

# Login Page
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        
        user = User.query.filter_by(email=email).first()
        if user and bcrypt.check_password_hash(user.password, password + user.salt):
            flash('Login successful!', 'success')
            return redirect(url_for('index'))
        else:
            flash('Login failed. Check your email or password', 'danger')
    
    return render_template('login.html')

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)
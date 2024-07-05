#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------
from flask import Flask, render_template, request, redirect, url_for, flash    # Flask framework
from models import db, bcrypt, User                                            # Flask-Bcrypt is a Flask extension for working with password hashing
from flask_sqlalchemy import SQLAlchemy                                        # SQLAlchemy allows to interact with databases
from dotenv import load_dotenv                                                 # Loads environment variables from the .env file
import os                                                                      # For dotenv

# Load Environment Variables from .env
load_dotenv()

# Connect to Database
app = Flask(__name__)                                                          # Flask application name 'app'
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')                             # Used env file
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('SQLALCHEMY_DATABASE_URI')   # Used env file
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False                           # To improve performance
db.init_app(app)                                                               # Connects Flask application to the database

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
@app.route('/register', methods=['GET', 'POST'])                               # GET used to display Register page, POST used to send the Registration data
def register():
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']
        
        # Salt to password
        salt = os.urandom(16).hex()
        # Hashing function
        hashed_password = bcrypt.generate_password_hash(password + salt).decode('utf-8')      # Hashing + salt saved
        
        new_user = User(username=username, email=email, password=hashed_password, salt=salt)  # Add to Database Table
        db.session.add(new_user)
        db.session.commit()
        
        flash('Registration successful!', 'success')                           # Succesful message
        return redirect(url_for('index'))                                      # Redirect to the main page
    
    return render_template('register.html')                                    # Failed message back to the Register Page

# Login Page
@app.route('/login', methods=['GET', 'POST'])                                  # GET used to display Login page, POST used to send data to database for Sign In
def login():
    if request.method == 'POST':
        email = request.form['email']                                          # Used Email and Password to Login
        password = request.form['password']
        
        user = User.query.filter_by(email=email).first()                       # Searches User with this Data
        if user and bcrypt.check_password_hash(user.password, password + user.salt):
            flash('Login successful!', 'success')                              # If Data is OK you get success
            return redirect(url_for('index'))
        else:
            flash('Login failed. Check your email or password', 'danger')      # If not you get a message of Failed
    
    return render_template('login.html')

# Run Application in port 80
if __name__ == '__main__':                                                     # Code will only be executed run directly
    with app.app_context():                                                    # Flask creates a temporary environment in which application has access to database
        db.create_all()                                                        # Create a Database Table
    app.run(debug=False, host='0.0.0.0', port=80)                              # Run in port 80

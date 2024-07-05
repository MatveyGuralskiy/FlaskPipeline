#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------
from flask_sqlalchemy import SQLAlchemy                                # SQLAlchemy allows to interact with databases
from flask_bcrypt import Bcrypt                                        # Bcrypt for password hashing

db = SQLAlchemy()                                                      # Initialize SQLAlchemy object for database operations
bcrypt = Bcrypt()                                                      # Initialize Bcrypt object for password encryption

# User Table
class User(db.Model):
    # Define columns for the User table
    id = db.Column(db.Integer, primary_key=True)                       # Primary key
    username = db.Column(db.String(150), unique=True, nullable=False)  # Username, unique and mandatory field
    email = db.Column(db.String(150), unique=True, nullable=False)     # Email, unique and mandatory field
    password = db.Column(db.String(200), nullable=False)               # Hashed password, mandatory field
    salt = db.Column(db.String(32), nullable=False)                    # Salt for password uniqueness

#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------
FROM postgres:latest

# Default Environment Variables
ARG POSTGRES_USER
ARG POSTGRES_PASSWORD
ARG POSTGRES_DB

ENV POSTGRES_USER=${POSTGRES_USER}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
ENV POSTGRES_DB=flask_db

# SQL script to create database
COPY init.sql /docker-entrypoint-initdb.d/

# Command to build Image:
    # docker build --build-arg POSTGRES_USER=YOUR-USER --build-arg POSTGRES_PASSWORD=YOUR-PASSWORD -t mydatabase:latest .
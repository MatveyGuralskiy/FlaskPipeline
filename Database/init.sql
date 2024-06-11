/*---------------------------
FlaskPipeline Project
Created by Matvey Guralskiy
---------------------------*/
-- Create Database PostgreSQL
CREATE DATABASE "$POSTGRES_DB";
CREATE USER "$POSTGRES_USER" WITH ENCRYPTED PASSWORD '$POSTGRES_PASSWORD';
GRANT ALL PRIVILEGES ON DATABASE "$POSTGRES_DB" TO "$POSTGRES_USER";
FROM python:3.9-slim

# Application Directory of Container
WORKDIR /app

# Copy all Flask requirements
COPY requirements.txt /app/

# Install all Application requirements
RUN pip install --no-cache-dir -r requirements.txt

# Copy all files to Container
COPY . /app/

# Expose port 80
EXPOSE 80

# Run Container
CMD ["python", "-u", "app.py"]
# Use an official Python runtime as a parent image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install required dependencies, including MariaDB connector and Flask
RUN pip install --no-cache-dir -r requirements.txt

# Ensure PyMySQL (MariaDB driver) is installed if not in requirements.txt
RUN pip install pymysql

# Expose port 5000 for Flask
EXPOSE 5000

# Run app.py when the container launches
CMD ["python", "app.py"]

# Define the base image
FROM python:3.10-alpine

# Copy files into the container
COPY . /app

# Install packages
RUN pip3 install -r /app/requirements.txt

# Expose a port for the app
EXPOSE 8000

# Start the app
ENTRYPOINT ["python3", "/app/app.py"]
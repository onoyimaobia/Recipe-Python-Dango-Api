# Use a lightweight official Python 3.13 Alpine Linux image
FROM python:3.13-alpine

# Set the maintainer label
LABEL maintainer="toochi"

# Set environment variable to output logs immediately (no buffering)
ENV PYTHONUNBUFFERED 1

# Copy requirements file into a temporary directory inside the container
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Copy the application code into /app directory inside the container
COPY ./app /app

# Set the working directory to /app
WORKDIR /app

# Expose port 8000 for external access (e.g., running Django or FastAPI app)
EXPOSE 8000

ARG DEV=false
# Set up Python virtual environment manually and install dependencies
# Create a virtual environment at /py
RUN python -m venv /py && \   
    # Upgrade pip inside the venv            
    /py/bin/pip install --upgrade pip && \
    # Install dependencies 
    /py/bin/pip install -r /tmp/requirements.txt && \ 
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    # Clean up temporary files
    rm -rf /tmp && \                  
    adduser \
        # Create a user without password     
        --disabled-password \ 
        # Do not create home directory            
        --no-create-home \  
        # User is named django-user                
        django-user                         

# Add the virtual environment to the PATH for easy command access
ENV PATH="/py/bin:$PATH"

# Switch to the non-root user for better container security
USER django-user

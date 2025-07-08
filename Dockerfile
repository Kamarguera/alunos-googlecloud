# Use the official lightweight Python image based on Alpine
FROM python:3.12-alpine

# Prevent python from writing .pyc files and ensure output is sent to terminal
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set the working directory in the container
WORKDIR /app

# Create a non-root user and group to run the application for better security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy only the requirements file to leverage Docker's layer caching
COPY --chown=appuser:appgroup requirements.txt .

# Install any needed packages specified in requirements.txt
# Use --no-cache-dir to keep the image size small
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY --chown=appuser:appgroup . .

# Switch to the non-root user
USER appuser

# Make port 8000 available to the world outside this container
EXPOSE 8000

# Run the application using uvicorn
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
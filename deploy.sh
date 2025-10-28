#!/bin/bash
set -e

# Define APP_DIR if not set
APP_DIR="/home/ec2-user/bug_tracker"

echo "Starting deployment in $APP_DIR..."
cd $APP_DIR

# Pull latest code (only if .git exists)
if [ -d ".git" ]; then
    echo "Pulling latest code from main branch..."
    git pull origin main
else
    echo "No git repository found, using existing code..."
fi

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

echo "Installing dependencies..."
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# Stop any existing application process
echo "Stopping any existing application processes..."
pkill -f "python3 app.py" || true
sleep 3

# Start the application
echo "Starting the application..."
nohup python3 app.py > $APP_DIR/app.log 2>&1 &
APP_PID=$!

echo "Application started with PID: $APP_PID"

# Wait and verify the application is running
sleep 5
if ps -p $APP_PID > /dev/null; then
    echo "Deployment successful! Application is running."
    echo "Check application status with: ps -p $APP_PID"
    echo "View logs with: tail -f $APP_DIR/app.log"
else
    echo "ERROR: Application failed to start!"
    echo "Check the logs for details: tail -f $APP_DIR/app.log"
    exit 1
fi

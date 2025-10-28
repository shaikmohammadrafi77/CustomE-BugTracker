#!/bin/bash
set -e

APP_DIR="/home/ec2-user/bug_tracker"

echo "Deploying to $APP_DIR..."
cd $APP_DIR

# Clone or update the repository
if [ -d ".git" ]; then
    echo "Updating repository..."
    git pull origin main
else
    echo "Cloning repository..."
    git clone https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git .
fi

# Create virtual environment
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

echo "Installing dependencies..."
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# Stop any existing application
echo "Stopping existing application..."
pkill -f "python3 app.py" || true
sleep 3

# Start the application
echo "Starting application..."
nohup python3 app.py > $APP_DIR/app.log 2>&1 &
APP_PID=$!
echo "Application started with PID: $APP_PID"

# Verify application is running
sleep 5
if ps -p $APP_PID > /dev/null; then
    echo "Deployment successful! Application is running."
    echo "Check logs: tail -f $APP_DIR/app.log"
else
    echo "ERROR: Application failed to start!"
    echo "Last 50 lines of log:"
    tail -50 $APP_DIR/app.log
    exit 1
fi

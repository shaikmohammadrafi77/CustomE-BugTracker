#!/bin/bash
set -e

cd /home/ec2-user/app
echo "Pulling latest code from main branch..."
git pull origin main

# Check if virtual environment exists, create if not
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

echo "Activating virtual environment and installing dependencies..."
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# Stop any existing application process
echo "Stopping any existing application processes..."
pkill -f "python3 app.py" || true
sleep 2

# Start the application in background
echo "Starting the application..."
nohup python3 app.py > app.log 2>&1 &
echo "Application started in background with PID: $!"

# Wait a moment and check if it's running
sleep 3
if pgrep -f "python3 app.py" > /dev/null; then
    echo "Deployment successful! Application is running."
    echo "Logs are being written to: /home/ec2-user/app/app.log"
else
    echo "WARNING: Application may not have started properly. Check app.log for details."
    exit 1
fi

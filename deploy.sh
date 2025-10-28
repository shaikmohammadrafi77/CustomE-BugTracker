#!/bin/bash
set -e

APP_DIR="/home/ec2-user/bug_tracker"

echo "🚀 Starting deployment in $APP_DIR..."
cd "$APP_DIR"

echo "📁 Current directory: $(pwd)"
echo "📄 Files in directory:"
ls -la

# Check if requirements.txt exists
if [ ! -f "requirements.txt" ]; then
    echo "❌ ERROR: requirements.txt not found!"
    exit 1
fi

# Create virtual environment
echo "🐍 Setting up virtual environment..."
python3 -m venv venv
source venv/bin/activate

echo "📦 Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Stop any existing application process
echo "🛑 Stopping any existing application processes..."
pkill -f "python3 app.py" || true
sleep 3

# Start the application
echo "🚀 Starting the application..."
nohup python3 app.py > "$APP_DIR/app.log" 2>&1 &
APP_PID=$!

echo "📝 Application started with PID: $APP_PID"

# Wait and verify the application is running
sleep 5
if ps -p $APP_PID > /dev/null; then
    echo "✅ Deployment successful! Application is running."
    echo "📜 View logs: tail -f $APP_DIR/app.log"
else
    echo "❌ ERROR: Application failed to start!"
    echo "📜 Check the logs:"
    tail -20 "$APP_DIR/app.log"
    exit 1
fi

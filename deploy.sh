#!/bin/bash
set -e

APP_DIR="/home/ec2-user/bug_tracker"
REPO_URL="https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git"

echo "🚀 Starting deployment in $APP_DIR..."
cd /home/ec2-user

# Clone or pull the repository
if [ -d "$APP_DIR/.git" ]; then
    echo "📥 Pulling latest changes..."
    cd "$APP_DIR"
    git pull origin main
else
    echo "📥 Cloning repository..."
    rm -rf "$APP_DIR"
    git clone "$REPO_URL" "$APP_DIR"
    cd "$APP_DIR"
fi

echo "📄 Files in directory:"
ls -la

# Check if requirements.txt exists
if [ ! -f "requirements.txt" ]; then
    echo "❌ ERROR: requirements.txt not found!"
    exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "🐍 Creating virtual environment..."
    python3 -m venv venv
fi

echo "📦 Installing dependencies..."
source venv/bin/activate
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
    echo "🔍 Check application: http://$(curl -s ifconfig.me):5000"
    echo "📜 View logs: tail -f $APP_DIR/app.log"
else
    echo "❌ ERROR: Application failed to start!"
    if [ -f "$APP_DIR/app.log" ]; then
        echo "=== Last 20 lines of app.log ==="
        tail -20 "$APP_DIR/app.log"
    fi
    exit 1
fi

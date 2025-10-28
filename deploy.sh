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
pkill -f "python3" || true
sleep 3

# Start the application - try different entry points
echo "🚀 Starting the application..."

# Check which entry point exists and use it
if [ -f "run.py" ]; then
    echo "📝 Using run.py as entry point..."
    nohup python3 run.py > "$APP_DIR/app.log" 2>&1 &
elif [ -f "app.py" ]; then
    echo "📝 Using app.py as entry point..."
    nohup python3 app.py > "$APP_DIR/app.log" 2>&1 &
elif [ -d "app" ] && [ -f "app/__init__.py" ]; then
    echo "📝 Using app package as entry point..."
    # If it's a package, you might need a different approach
    # Let's try running from the app directory or using a module
    nohup python3 -m app > "$APP_DIR/app.log" 2>&1 &
else
    echo "❌ ERROR: No application entry point found!"
    echo "Available Python files:"
    find . -name "*.py" -type f
    exit 1
fi

APP_PID=$!
echo "📝 Application started with PID: $APP_PID"

# Wait and verify the application is running
sleep 5
if ps -p $APP_PID > /dev/null; then
    echo "✅ Deployment successful! Application is running."
    echo "📜 View logs: tail -f $APP_DIR/app.log"
    echo "🌐 Application should be accessible shortly..."
else
    echo "❌ ERROR: Application failed to start!"
    echo "📜 Check the logs:"
    if [ -f "$APP_DIR/app.log" ]; then
        tail -20 "$APP_DIR/app.log"
    else
        echo "No log file found at $APP_DIR/app.log"
    fi
    exit 1
fi

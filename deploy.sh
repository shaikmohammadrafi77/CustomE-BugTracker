#!/bin/bash
set -e  # Exit immediately if a command fails
APP_DIR="/home/ec2-user/CustomE-BugTracker"
REPO_URL="https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git"
LOG_FILE="$APP_DIR/app.log"

echo "🚀 Starting deployment..."

# Check if the app directory exists, else clone
if [ ! -d "$APP_DIR" ]; then
    echo "📁 Cloning repository..."
    git clone "$REPO_URL" "$APP_DIR"
else
    echo "🔄 Pulling latest changes..."
    cd "$APP_DIR"
    git fetch origin main
    git reset --hard origin/main
fi

# Navigate to the app directory
cd "$APP_DIR"

# Setup Python virtual environment
if [ ! -d "venv" ]; then
    echo "🐍 Creating Python virtual environment..."
    python3 -m venv venv
fi

# Activate venv and install dependencies
echo "📦 Installing dependencies..."
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# Kill any existing app process (optional, prevents duplicates)
echo "🛑 Stopping old app if running..."
pkill -f "python3 app.py" || true

# Start the app
echo "🚀 Starting the application..."
nohup python3 app.py > "$LOG_FILE" 2>&1 &

echo "✅ Deployment successful! Logs at $LOG_FILE"

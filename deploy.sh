#!/bin/bash
set -e

APP_DIR="/home/ec2-user/CustomE-BugTracker"
REPO_URL="https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git"

# Clone repo if not present
if [ ! -d "$APP_DIR/.git" ]; then
    echo "📂 Cloning repository for the first time..."
    git clone "$REPO_URL" "$APP_DIR"
else
    echo "🔄 Repository already exists. Pulling latest changes..."
    cd "$APP_DIR"
    git pull origin main
fi

cd "$APP_DIR"

echo "🐍 Setting up Python environment..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

. venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

echo "🚀 Starting Flask app..."
# Kill existing app process if running
pkill -f "python3 app.py" || true
nohup python3 app.py > app.log 2>&1 &

echo "✅ Deployment successful!"

#!/bin/bash
set -e

APP_DIR="/home/ec2-user/app"
REPO_URL="https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git"

# Create or update app directory
cd $APP_DIR

# If repo not cloned yet, clone it
if [ ! -d ".git" ]; then
    git clone $REPO_URL .
else
    git pull origin main
fi

# Stop any existing app.py process
echo "Stopping old app process (if running)..."
pkill -f "python3 app.py" || true

# Setup virtual environment
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# Start application
nohup python3 app.py > app.log 2>&1 &

echo "✅ Deployment successful!"

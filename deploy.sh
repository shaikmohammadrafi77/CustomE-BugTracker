#!/bin/bash
set -e

# Define app directory
APP_DIR="/home/ec2-user/CustomE-BugTracker"

# Clone or update the repo
if [ ! -d "$APP_DIR" ]; then
    echo "📁 Cloning repository..."
    git clone https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git "$APP_DIR"
else
    echo "🔄 Updating repository..."
    cd "$APP_DIR"
    git pull origin main
fi

# Setup virtual environment
cd "$APP_DIR"
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# Run the app
nohup python3 app.py > app.log 2>&1 &
echo "✅ Deployment successful!"

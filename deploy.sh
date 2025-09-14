#!/bin/bash
set -e
cd /home/ec2-user/CustomE-BugTracker
git clone https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git

python3 -m venv venv
. venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
pkill -f "python3 app.py" || true
nohup python3 app.py >app.log 2>&1 &
echo "deployment succesfully!"

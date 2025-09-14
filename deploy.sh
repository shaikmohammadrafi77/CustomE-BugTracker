#!/bin/bash
set -e
cd /home/ec2-user/CustomE-BugTracker
git pull origin main

python3 -m venv venv
. venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
python3 app.py || true
nohup python3 app.py >app.log 4>&1 &
echo "deployment succesfully!"

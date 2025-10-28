#!/bin/bash
set -e
cd ${APP_DIR}
git pull origin main

python3 -m venv venv
. venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
pkill -f "python3 app.py" || true
nohup python3 app.py >app.log 2>&1 &
echo "deployment succesfully!"

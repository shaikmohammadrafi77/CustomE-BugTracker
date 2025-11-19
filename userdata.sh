#!/bin/bash

yum update -y

# Install Python 3.9 and git
amazon-linux-extras enable python3.9
yum install -y python3.9 python3.9-pip git

# Upgrade pip
python3.9 -m pip install --upgrade pip

cd /home/ec2-user

# Clone your actual repository
git clone https://github.com/shaikmohammadrafi77/e-bugtracker.git

# Move into project folder
cd e-bugtracker/Project

# Create virtual environment
python3.9 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Set Flask environment variables
export FLASK_APP=app.py
export FLASK_ENV=development

# Run Flask application
nohup flask run --host=0.0.0.0 --port=5000 &

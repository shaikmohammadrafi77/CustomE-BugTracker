#!/bin/bash
# Update packages
yum update -y

# Install Python 3.9 and git
amazon-linux-extras enable python3.9
yum install -y python3.9 python3.9-pip git

# Upgrade pip
python3.9 -m pip install --upgrade pip

# Navigate to home directory
cd /home/ec2-user

# Clone your GitHub project (replace with your repo)
git clone https://github.com/username/your-repo.git
cd your-repo

# Create and activate virtual environment
python3.9 -m venv venv
source venv/bin/activate

# Install project dependencies
pip install -r requirements.txt

# Export Flask app environment variable
export FLASK_APP=run.py
export FLASK_ENV=development  # change to production if needed

# Run the Flask app on 0.0.0.0 so it's accessible publicly
nohup flask run --host=0.0.0.0 --port=5000 &

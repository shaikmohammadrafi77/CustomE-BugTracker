#!/bin/bash
sudo yum update –y
Sudo yum install git -y
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo yum install java-21-amazon-corretto -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins







# Custom E-Bug Tracker




## Project Overview
This is an **Electronic Bug Tracking System** developed using Python and Flask.    
It allows software teams to **record, assign, and resolve bugs** 

## Repository
You can access the project on GitHub:  
[https://github.com/shaikmohammadrafi77/CustomE-BugTracker](https://github.com/shaikmohammadrafi77/CustomE-BugTracker)

## Folder Structure
├── pycache/ # Python cache files (auto-generated)
├── .vscode/ # VSCode configuration files
├── app/ # Core application code (routes, models, templates)
├── instance/ # Environment-specific configuration (DB, secrets)
├── venv/ # Python virtual environment
├── config.py # Global configuration file
├── requirements.txt # Project dependencies
├── run.py # Application startup script
└── userdata.sh # EC2 setup script for automatic environment configuration

## Features
- User authentication and authorization
- Bug creation, assignment, and status tracking
- Dashboard to monitor bug reports
- EC2 deployment ready with `userdata.sh`

## How to Run Locally
1. **Clone the repository**: : "
   ```bash
   git clone https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git
   cd CustomE-BugTracker
Create and activate virtual environment:
python3 -m venv venv
source venv/bin/activate   # Linux/Mac
venv\Scripts\activate      # Windows
Install dependencies:
pip install -r requirements.txt
Run the Flask app:
export FLASK_APP=run.py
export FLASK_ENV=development
flask run
Open your browser at http://127.0.0.1:5000/
jenkins ia opensource automate tool

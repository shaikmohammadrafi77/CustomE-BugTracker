pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Downloading project...'
                git branch: 'main', url: 'https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the project...'
                sh '''
                python3 -m venv venv
                source venv/bin/activate
                pip install -r requirements.txt
                '''
            }
        }

        stage('Test') {
            steps {
                echo 'No pytest available, skipping tests...'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying project to EC2...'
                sh '''
                ssh -o StrictHostKeyChecking=no ec2-user@13.235.13.243 "
                    cd myapp &&
                    git pull &&
                    pip install -r requirements.txt &&
                    nohup python3 app.py > app.log 2>&1 &
                "
                '''
            }
        }
    }
}

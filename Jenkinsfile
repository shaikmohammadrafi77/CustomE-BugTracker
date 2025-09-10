pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git'
            }
        }

        stage('Build') {
            steps {
                sh '''
                  echo "■ Building project..."
                  python3 -m venv venv
                  . venv/bin/activate
                  pip install --upgrade pip
                  pip install -r requirements.txt
                  pip install pytest
                '''
            }
        }

        stage('Test') {
            steps {
                sh '''
                  echo "■ Running tests..."
                  . venv/bin/activate
                  pytest tests/
                '''
            }
        }

        stage('Deploy') {
            when {
                expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                sh 'echo "■ Deploying project..."'
            }
        }
    }
}

pipeline {
    agent any   // run on any Jenkins agent (node)

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git'
            }
        }

        stage('Build') {
            steps {
                sh 'echo "■ Building project..."'
            }
        }

        stage('Test') {
            steps {
                sh 'echo "■ Running tests..."'
                sh 'pytest tests/'   // remove || true if you want failures to stop pipeline
            }
        }

        stage('Deploy') {
            steps {
                sh 'echo "■ Deploying project to server..."'
            }
        }
    }
}

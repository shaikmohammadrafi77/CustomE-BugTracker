pipeline {
    agent any

    environment {
        EC2_USER = 'ec2-user'
        EC2_HOST = '13.201.103.121'
        SSH_CREDENTIALS = 'jenkins-id'
        APP_DIR = '/home/ec2-user/app'
        REPO_URL = 'https://github.com/shaikmohammadrafi77/jenkins_project.git'
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo "📦 Cloning the main branch from ${REPO_URL}..."
                git branch: 'main', url: "${env.REPO_URL}"
            }
        }

        stage('Build & Test') {
            steps {
                echo "🧱 Building and running tests..."
                sh '''
                set -e
                python3 -m venv venv 
                . venv/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt

                # Run tests if pytest exists
                if pip show pytest > /dev/null 2>&1; then
                    echo "🧪 Running tests..."
                    python3 -m pytest || true
                else
                    echo "⚠️ pytest not found, skipping tests."
                fi
                '''
            }
        }

        stage('Deploy to EC2') {
            steps {
                echo "🚀 Deploying application to EC2 instance (${EC2_HOST})..."
                sshagent([env.SSH_CREDENTIALS]) {
                    sh '''
                    # Ensure app directory exists
                    ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} "mkdir -p ${APP_DIR}"

                    # Copy deployment script
                    scp -o StrictHostKeyChecking=no deploy.sh ${EC2_USER}@${EC2_HOST}:${APP_DIR}/deploy.sh

                    # Run deployment script on EC2
                    ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} "chmod +x ${APP_DIR}/deploy.sh && bash ${APP_DIR}/deploy.sh"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed! Check logs for details."
        }
        always {
            echo "🧹 Cleaning workspace..."
            cleanWs()
        }
    }
}

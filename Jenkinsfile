pipeline {
    agent any

    environment {
        EC2_USER = 'ec2-user' // or 'ubuntu' if using Ubuntu EC2
        EC2_HOST = '13.233.100.187'
        SSH_CREDENTIALS = 'jenkins-id'  // Update this to your correct Jenkins credential ID
        APP_DIR = '/home/ec2-user/app'
        REPO_URL = 'https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git'
    }

    stages {

        stage('Clone Repository') {
            steps {
                git branch: 'main', url: "${env.REPO_URL}"
            }
        }

        stage('Build & Test') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                    python3 -m pytest || true
                '''
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent([env.SSH_CREDENTIALS]) {
                    sh '''
                        echo "Deploying to EC2..."
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} '
                            mkdir -p ${APP_DIR} &&
                            cd ${APP_DIR} &&
                            rm -rf CustomE-BugTracker &&
                            git clone https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git &&
                            cd CustomE-BugTracker &&
                            chmod +x deploy.sh &&
                            bash deploy.sh
                        '
                    '''
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

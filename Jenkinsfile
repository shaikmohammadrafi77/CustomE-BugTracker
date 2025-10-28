pipeline {
    agent any
    environment {
        EC2_USER = 'ec2-user'
        EC2_HOST = '13.201.103.121'
        SSH_CREDENTIALS = 'jenkins-id'
        APP_DIR = '/home/ec2-user/bug_tracker'
        REPO_URL = 'https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git'
    }
    stages {
        stage('clone') {
            steps {
                git branch: 'main', url: "${env.REPO_URL}"
            }
        }
        stage('build & test') {
            steps {
                sh '''
                    python3 -m venv venv 
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                    pip install pytest
                    python3 -m pytest || true
                '''
            }
        }
        stage('deploy') {
            steps {
                sshagent([env.SSH_CREDENTIALS]) {
                    sh """
                        # Just copy the deploy.sh script
                        ssh -o StrictHostKeyChecking=no ${env.EC2_USER}@${env.EC2_HOST} 'mkdir -p ${env.APP_DIR}'
                        scp -o StrictHostKeyChecking=no deploy.sh ${env.EC2_USER}@${env.EC2_HOST}:${env.APP_DIR}/
                        ssh -o StrictHostKeyChecking=no ${env.EC2_USER}@${env.EC2_HOST} 'cd ${env.APP_DIR} && chmod +x deploy.sh && bash deploy.sh'
                    """
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

pipeline {
    agent any
    environment {
        EC2_USER = 'ec2-user'
        EC2_HOST = '18.205.19.89'
        SSH_CREDENTIALS = 'jenkins-id'
        APP_DIR = '/home/ec2-user/bug_tracker'
    }
    stages {
        stage('clone') {
            steps {
                git branch: 'main', url: 'https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git'
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
                        # Clean and recreate directory
                        ssh -o StrictHostKeyChecking=no ${env.EC2_USER}@${env.EC2_HOST} 'rm -rf ${env.APP_DIR} && mkdir -p ${env.APP_DIR}'
                        
                        # Copy all files except venv
                        tar --exclude='venv' --exclude='.git' -czf - . | ssh -o StrictHostKeyChecking=no ${env.EC2_USER}@${env.EC2_HOST} 'cd ${env.APP_DIR} && tar -xzf -'
                        
                        # Run deployment
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

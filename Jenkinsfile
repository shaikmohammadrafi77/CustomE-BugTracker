pipeline {
    agent any

    environment {
        EC2_USER = 'ec2-user'
        EC2_IP   = '13.235.13.243'       // Replace with your EC2 IP
        APP_DIR  = '/home/ec2-user/myapp' // Path to your app on EC2
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Cloning repository..."
                git branch: 'main', url: 'https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git'
            }
        }

        stage('Build') {
            steps {
                echo "Setting up Python virtual environment..."
                sh '''
                    python3 -m venv venv
                    source venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying to EC2..."
                sshagent(['ec2-key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_IP \\
                    \"
                    cd $APP_DIR &&
                    git pull &&
                    source venv/bin/activate &&
                    pip install -r requirements.txt &&
                    sudo systemctl restart myapp.service
                    \"
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Deployment successful! 🎉"
        }
        failure {
            echo "Deployment failed. Check logs for details."
        }
    }
}

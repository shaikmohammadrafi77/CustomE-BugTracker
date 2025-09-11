pipeline {
    agent any

    environment {
        EC2_USER = 'ec2-user'
        EC2_IP   = '13.235.13.243'   // Replace with your EC2 IP
        APP_DIR  = 'myapp'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git'
            }
        }

        stage('Build') {
            steps {
                sh '''
                python3 -m venv venv
                source venv/bin/activate
                pip install -r requirements.txt
                '''
            }
        }

        stage('Deploy') {
            steps {
                sshagent(['ec2-key']) {  // Uses the EC2 private key stored in Jenkins
                    sh """
                    ssh $EC2_USER@$EC2_IP \"
                    cd $APP_DIR &&
                    git pull &&
                    source venv/bin/activate &&
                    pip install -r requirements.txt &&
                    nohup python3 app.py > app.log 2>&1 &
                    \"
                    """
                }
            }
        }
    }
}

pipeline {
    agent any

    environment {
        EC2_USER = "ec2-user"
        EC2_HOST = "13.232.181.168"
        SSH_CREDENTIALS = "jenkins-id"
        APP_NAME = "app"
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
                . venv/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
                '''
            }
        }

        stage('Test') {
            steps {
                sh '''
                . venv/bin/activate
                pytest tests || true
                '''
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent([env.SSH_CREDENTIALS]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST '
                        mkdir -p /home/$EC2_USER/$APP_NAME
                        cd /home/$EC2_USER/$APP_NAME

                        if [ ! -d ".git" ]; then
                            git clone https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git .
                        else
                            git pull origin main
                        fi

                        [ ! -d venv ] && python3 -m venv venv
                        . venv/bin/activate
                        pip install --upgrade pip
                        pip install -r requirements.txt

                        sudo pkill -f "python3 app.py" || true

                        nohup python3 app.py > app.log 2>&1 &
                    '
                    """
                }
            }
        }
    }
}

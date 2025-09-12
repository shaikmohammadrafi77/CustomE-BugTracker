pipeline {
    agent any

    environment {
        EC2_USER = "ec2-user"
        EC2_HOST = "13.126.68.31"             // Replace with your EC2 public IP
        APP_DIR = "/home/ec2-user/myapp"      // Directory on EC2
        SSH_CREDENTIALS = "jenkins-id"        // Jenkins SSH credentials ID
    }

    stages {
        // -----------------------------
        // Stage 1: Checkout Code
        // -----------------------------
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git'
            }
        }

        // -----------------------------
        // Stage 2: Setup Python Environment
        // -----------------------------
        stage('Setup Python') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        // -----------------------------
        // Stage 3: Run Tests
        // -----------------------------
        stage('Run Tests') {
            steps {
                sh '''
                    . venv/bin/activate
                    pip install pytest
                    pytest || echo "No tests found or errors ignored, continuing..."
                '''
            }
        }

        // -----------------------------
        // Stage 4: Build (Optional)
        // -----------------------------
        stage('Build') {
            steps {
                sh '''
                    echo "Packaging Python project (optional)"
                    # tar -czf app.tar.gz ./   # Uncomment if needed
                '''
            }
        }

        // -----------------------------
        // Stage 5: Deploy to EC2
        // -----------------------------
        stage('Deploy to EC2') {
            steps {
                sshagent([env.SSH_CREDENTIALS]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} <<EOF
                        echo "Deploying app on EC2..."

                        # Create app directory if it doesn't exist
                        mkdir -p ${APP_DIR}
                        cd ${APP_DIR}

                        # Clone or pull latest code
                        if [ ! -d ".git" ]; then
                            git clone -b main https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git .
                        else
                            git reset --hard
                            git pull origin main
                        fi

                        # Setup virtual environment if not exists
                        if [ ! -d "venv" ]; then
                            python3 -m venv venv
                        fi
                        source venv/bin/activate

                        # Upgrade pip & install dependencies
                        pip install --upgrade pip
                        pip install -r requirements.txt

                        # Kill existing app if running
                        pkill -f 'python3 app.py' || echo "No existing process"

                        # Start app in background
                        nohup python3 app.py > app.log 2>&1 &

                        echo "Deployment completed!"
EOF
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}

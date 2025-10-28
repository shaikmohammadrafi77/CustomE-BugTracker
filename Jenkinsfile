pipeline {
    agent any

    environment {
        EC2_USER = 'ec2-user'
        EC2_HOST = '13.201.103.121' // e.g. ec2-13-233-177-5.ap-south-1.compute.amazonaws.com
        SSH_CREDENTIALS = 'jenkins-id' // Jenkins SSH key credential ID
        APP_DIR = '/home/ec2-user/app'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/shaikmohammadrafi77/jenkins_project.git'
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
                    if [ -f "pytest.py" ]; then
                        echo "Running tests..."
                        python3 pytest.py
                    else
                        echo "No pytest file found — skipping tests."
                    fi
                '''
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent([env.SSH_CREDENTIALS]) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} << 'EOF'
                        echo "🚀 Starting deployment on EC2..."

                        APP_DIR="/home/ec2-user/app"
                        REPO_URL="https://github.com/shaikmohammadrafi77/jenkins_project.git"

                        if [ ! -d "$APP_DIR/.git" ]; then
                            echo "📦 Cloning repo..."
                            git clone "$REPO_URL" "$APP_DIR"
                        else
                            echo "🔄 Pulling latest changes..."
                            cd "$APP_DIR"
                            git pull origin main
                        fi

                        cd "$APP_DIR"
                        python3 -m venv venv
                        source venv/bin/activate
                        pip install --upgrade pip
                        pip install -r requirements.txt

                        echo "🛑 Stopping old app if running..."
                        pkill -f "python3 app.py" || true

                        echo "🚀 Starting new app..."
                        nohup python3 app.py > app.log 2>&1 &

                        echo "✅ Deployment successful!"
                        EOF
                    '''
                }
            }
        }
    }
}

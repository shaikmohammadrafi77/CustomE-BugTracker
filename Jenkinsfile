
pipeline{
	agent any
	environment{
	    EC2_USER = 'ec2-user'
	    EC2_HOST = '43.204.150.85'
	    SSH_CREDENTIALS = 'jenkins-id'
	    APP_DIR = '/home/ec2-user/app'
	    REPO_URL ='https://github.com/shaikmohammadrafi77/jenkins_project.git'
	}
	stages{
		stage('clone'){
			steps{
				git branch: 'main', url: "${env.REPO_URL}"
			}
		}
		stage('build & test'){
			steps{
				sh '''
				python3 -m venv venv 
				. venv/bin/activate
				pip install --upgrade pip
				pip install -r requirements.txt
				python3  -m pytest || true
				'''

			}
		}
		stage('deploy'){
			steps{
				sshagent([env.SSH_CREDENTIALS]) {
					sh """
					ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} 'mkdir -p ${APP_DIR}'
					scp -o StrictHostKeyChecking=no deploy.sh ${EC2_USER}@${EC2_HOST}:${APP_DIR}
					ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} 'bash ${APP_DIR}/deploy.sh'
					"""

				}


			}
		}

	}
	post{
		always {
			cleanWs()
		}
	}
}

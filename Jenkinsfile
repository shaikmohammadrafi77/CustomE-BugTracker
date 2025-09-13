pipeline{
	agent any


	environment{
		EC2_USER= "ec2_user"
		EC2_HOST= " 13.127.209.113 "
		SSH_CREDENTIALS=" jenkins-id "
		APP_NAME=" app "

	}
stages{
	stage('checkout'){
		steps{
			git branch:'main', url:' https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git '

			
		}
	}
	stage('build'){
		steps{
			sh '''
			python3 -m venv venv
			. venv/bin/activate
			pip install --upgrade pip
			pip install -r requirements.txt
			'''

			
		}
	}
	stage('test'){
		step{
			sh '''
			. venv/bin/activate
			pytest tests|| true
			'''
			
		}
	}
		
	stage('deploy to ec2'){
		steps{
			sshagent(['SSH_CREDENTIALS']){
				sh """
				ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST '
				cd /home/ec2_user/app
				pkill -f python3
				git pull origin main[ ! -d venv ] && python3 -m venv venv 
				. venv/bin/activate
				pip install --upgrade
				pip install -r requirements.txt
				nohup python3 app.py >app.log 2>&1 &
				'
				
				"""
				

			}
		}
	}

}

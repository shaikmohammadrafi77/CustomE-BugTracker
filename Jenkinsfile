pipeline{
  agent any
  stages{
    stage('checkout'){ 
      steps{
        echo 'download source code '
        git branch: 'main', url: 'https://github.com/shaikmohammadrafi77/CustomE-BugTracker.git ...'
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
      steps{
        echo ' no available pytest , skipping '
      }
    }
    stage('deploy'){
      steps{
        
        echo 'deploy to ec2 '
        sshagent(['jenkins_id']){
        sh '''
        scp -o StrictHostKeyChecking=no -r * ec2-user@172.31.33.27:/home/ec2-user/app/
        ssh ec2-user@172.31.33.27  "bash /home/ec2-user/app/shutdown.sh"
         ssh ec2-user@172.31.33.27 "bash /home/ec2-user/app/bin/startup.sh"
        
         '''
        }
        
      }
    }
  }
}

    

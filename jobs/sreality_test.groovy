pipeline {
    agent any        

    stages {
        stage('Build') {
            steps {
                git branch: 'main', url: 'https://github.com/Michal-Pokorny/reality'
            }
        }
        stage('Prepare Docker') {
            steps {
                powershell '''docker-compose build'''
            }
        }
        stage('Run Test') {
            steps {              
                powershell "docker-compose run robot robot --include Fast_Test execution/sreality.robot"                
            }
        }
        stage('Publish Results') {
            steps {
                robot archiveDirName: 'robot-plugin', outputPath: '', overwriteXAxisLabel: ''
            }
        }
    }
}



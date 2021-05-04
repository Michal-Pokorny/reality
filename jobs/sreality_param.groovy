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
                echo "Parameters: ${env.Type}, ${env.Realty}, ${env.Location}, ${env.Size}, ${env.Search_limit}, ${env.Search_type}, ${env.Age}"
                powershell "docker-compose run robot robot --include Param --variable auction_type:${env.Type} --variable realty:${env.Realty} --variable location:${env.Location} --variable size:${env.Size} --variable starttime:${env.BUILD_TIMESTAMP_PATH} --variable search_limit:${env.Search_limit} --variable search_type:${env.Search_type} --variable age:${env.Age} execution/sreality.robot"                
            }
        }
        stage('Send E-mail') {
            when{
                expression {env.Recipients}
            }
            steps {
                echo "Sending results to ${env.Recipients}"
                zip zipFile: 'results.zip', archive: false, dir: "results/${env.BUILD_TIMESTAMP_PATH}"
                emailext attachmentsPattern: 'results.zip', body: '''See attached results of ${env.BUILD_TAG} from ${env.BUILD_TIMESTAMP}''', subject: "SReality - Results", mimeType: 'text/html',to: env.Recipients
                cleanWs(patterns: [[pattern: 'results.zip', type: 'INCLUDE']])
            }
        }
        stage('Publish Results') {
            steps {
                robot archiveDirName: 'robot-plugin', outputPath: '', overwriteXAxisLabel: ''
            }
        }
    }
}



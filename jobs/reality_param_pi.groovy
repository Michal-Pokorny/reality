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
                sh '''docker-compose build'''
            }
        }
        stage('Run Test') {
            steps {
                echo "Executing: docker-compose run robot robot --include Param --variable engine:pi --variable auctionplace:${env.Source} --variable auction_type:${env.Type} --variable realty:${env.Realty} --variable location:${env.Location} --variable size:${env.Size} --variable starttime:${env.BUILD_TIMESTAMP_PATH} --variable search_limit:${env.Search_limit} --variable search_type:${env.Search_type} --variable age:${env.Age} execution/reality.robot"
                sh "docker-compose run robot robot --include Param --variable engine:pi --variable auctionplace:${env.Source} --variable auction_type:${env.Type} --variable realty:${env.Realty} --variable location:${env.Location} --variable size:${env.Size} --variable starttime:${env.BUILD_TIMESTAMP_PATH} --variable search_limit:${env.Search_limit} --variable search_type:${env.Search_type} --variable age:${env.Age} execution/reality.robot"                
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
    }
    post {
    	always{
    		robot archiveDirName: 'robot-plugin', outputPath: '', overwriteXAxisLabel: ''
    	}
    }
}



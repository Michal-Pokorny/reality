pipelineJob('demo1') {	
    pipeline {
    agent any
    
    parameters{
    	choiceParam(
  			'Type', ['prodej','pronajem','drazby','projekt']
  		)        
        choiceParam(
        	'Realty', ['byty','domy','pozemky','komercni','ostatni']
        )        
        choiceParam(
        	'Location', ['praha','stredocesky-kraj','ustecky-kraj','karlovarsky-kraj','plzensky-kraj','jihocesky-kraj','vysocina-kraj','pardubicky-kraj','kralovehradecky-kraj','liberecky-kraj','olomoucky-kraj','moravskoslezsky-kraj','zlinsky-kraj','jihomoravsky-kraj','all']
        )                        
   		stringParam(
   			'Recipients', description: 'Sends E-mail with results to recipient(s)'
   		)
    }    

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
                cleanWs(patterns: [[pattern: 'results/*.csv', type: 'INCLUDE']])
                echo "Parameters: ${env.Type}, ${env.Realty}, ${env.Location}"
                powershell "docker-compose run robot robot --include Param --variable auction_type:${env.Type} --variable realty:${env.Realty} --variable location:${env.Location} --variable size:${env.Size} execution/sreality.robot"
                
            }
        }
        stage('Send E-mail') {
            when{
                expression {env.Recipients}
            }
            steps {
                echo "Sending results to ${env.Recipients}"
                zip zipFile: 'results.zip', archive: false, dir: 'results'
                emailext attachmentsPattern: 'results.zip', body: '''See attached results of SReality job''', subject: "SReality - Results", mimeType: 'text/html',to: env.Recipients
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
}



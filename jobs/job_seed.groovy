pipelineJob('demo1') {	 
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
   			'Recipients', 'Sends E-mail with results to recipient(s)'
   		)
    } 
    
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        github('https://github.com/Michal-Pokorny/reality')
                    }
                }
            }
            scriptPath('jobs/sreality_param.groovy')
        }
    }   
}



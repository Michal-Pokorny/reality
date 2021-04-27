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
        activeChoiceReactiveParam('Size') {
            choiceType('SINGLE_SELECT')
            groovyScript {
                script('''
def choices
switch(Realty){
case "byty":
    choices = ["1+kk","1+1","2+kk","2+1","3+kk","3+1","4+kk","4+1","5+kk","5+1","6-a-vice","atypicky","All"]
    break
case "domy":
	choices = ["1-pokoj","2-pokoje","3-pokoje","4-pokoje","5-a-vice","atypicky","All"]
	break
case "pozemky":
	choices = ["stavebni-parcely","komercni-pozemky","pole","louky","lesy","rybniky","sady-vinice","zahrady","ostatni-pozemky","All"]
	break
case "komercni":
	choices = ["kancelare","sklady","vyrobni-prostory","obchodni-prostory","ubytovani","restaurace","zemedelske-objekty","cinzovni-domy","ostatni-komercni-prostory","All"]
	break
case "ostatni":
	choices = ["garaze","garazova-stani","mobilheimy","vinne-sklepy","pudni-prostory","jine-nemovitosti","All"]
	break
default:
	choices = ["All"]
	break
}
return choices
				''')
                fallbackScript('return ["All"]')
            }
            referencedParameter('Realty')
        }                        
   		stringParam(
   			'Recipients', '', 'Sends E-mail with results to recipient(s)'
   		)
    } 
    
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        github('Michal-Pokorny/reality')
                    }
                }
            }
            scriptPath('jobs/sreality_param.groovy')
        }
    }   
}



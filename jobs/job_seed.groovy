pipelineJob('SReality - Parameters') {	 
    parameters{
    	choiceParam(
  			'Source', ['sreality','idnes']
  		)
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
                script('''def choices
switch(Realty){
case "byty":
    choices = ["1+kk","1+1","2+kk","2+1","3+kk","3+1","4+kk","4+1","5+kk","5+1","6-a-vice","atypicky","all"]
    break
case "domy":
	choices = ["1-pokoj","2-pokoje","3-pokoje","4-pokoje","5-a-vice","atypicky","all"]
	break
case "pozemky":
	choices = ["stavebni-parcely","komercni-pozemky","pole","louky","lesy","rybniky","sady-vinice","zahrady","ostatni-pozemky","all"]
	break
case "komercni":
	choices = ["kancelare","sklady","vyrobni-prostory","obchodni-prostory","ubytovani","restaurace","zemedelske-objekty","cinzovni-domy","ostatni-komercni-prostory","all"]
	break
case "ostatni":
	choices = ["garaze","garazova-stani","mobilheimy","vinne-sklepy","pudni-prostory","jine-nemovitosti","all"]
	break
default:
	choices = ["all"]
	break
}
return choices
				''')
                fallbackScript('return ["all"]')
            }
            referencedParameter('Realty')
        }
        choiceParam(
        	'Age', ['all','dnes','tyden','mesic']
        )                        
   		stringParam(
   			'Recipients', '', 'Sends E-mail with results to recipient(s)'
   		)
   		stringParam(
   			'Search_limit', '1', 'Limits pages searched by the test (0=no limit)'
   		)
   		choiceParam(
        	'Search_type', ['detail','basic','fast']
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
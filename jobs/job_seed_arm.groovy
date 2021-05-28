pipelineJob('Reality - Parameters') {	 
    parameters{
    	choiceParam(
  			'Source', ['sreality','idnes']
  		)
    	activeChoiceReactiveParam('Type') {
            choiceType('SINGLE_SELECT')
            groovyScript {
                script('''def choices
switch(Source){
case "sreality":
    choices = ["prodej","pronajem","drazby","projekt"]
    break
case "idnes":
	choices = ["prodej","pronajem","vymena","drazba"]
	break
default:
	choices = ["prodej"]
	break}
return choices
				''')
                fallbackScript('return ["prodej"]')
            }
            referencedParameter('Source')
        }        
        activeChoiceReactiveParam('Realty') {
            choiceType('SINGLE_SELECT')
            groovyScript {
                script('''def choices
switch(Source){
case "sreality":
    choices = ["byty","domy","pozemky","komercni","ostatni"]
    break
case "idnes":
	choices = ["byty","domy","pozemky","komercni-nemovitosti","male-objekty-garaze"]
	break
default:
	choices = ["byty"]
	break}
return choices
				''')
                fallbackScript('return ["byty"]')
            }
            referencedParameter('Source')
        }        
        choiceParam(
        	'Location', ['praha','stredocesky-kraj','ustecky-kraj','karlovarsky-kraj','plzensky-kraj','jihocesky-kraj','vysocina-kraj','pardubicky-kraj','kralovehradecky-kraj','liberecky-kraj','olomoucky-kraj','moravskoslezsky-kraj','zlinsky-kraj','jihomoravsky-kraj','all']
        )
        activeChoiceReactiveParam('Size') {
            choiceType('SINGLE_SELECT')
            groovyScript {
                script('''def choices
switch(Source){
case "sreality":
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
	break}
break	
case "idnes":
switch(Realty){
case "byty":
    choices = ["1+kk","1+1","2+kk","2+1","3+kk","3+1","4+kk","4+1","5+kk","atypicke","all"]
    break
case "domy":
	choices = ["rodinne","chata-chalupa","na-klic","jine","all"]
	break
case "pozemky":
	choices = ["stavebni-pozemek","pro-komercni-vyuziti","zemedelsky","les","zahrady","louka","vodni-plocha","jine","all"]
	break
case "komercni-nemovitosti":
	choices = ["kancelare","obchody","sklady","vyroba","ubytovani","restaurace","najemni-domy","zemedelsky","jine","all"]
	break
case "male-objekty-garaze":
	choices = ["all"]
	break
default:
	choices = ["all"]
	break}
break
default:
choices = ["all"]
break}             
return choices
				''')
                fallbackScript('return ["all"]')
            }
            referencedParameter('Realty, Source') 
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
            scriptPath('jobs/reality_param_arm.groovy')
        }
    }   
}
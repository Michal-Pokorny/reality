def choices
switch(Realty){
    case 'byty':
        choices = ['1+kk','1+1','2+kk','2+1','3+kk','3+1','4+kk','4+1','5+kk','5+1','6-a-vice','atypicky']
        break
    case 'domy':
        choices = ['1-pokoj','2-pokoje','3-pokoje','4-pokoje','5-a-vice','atypicky']
        break
    case 'pozemky':
        choices = ['stavebni-parcely','komercni-pozemky','pole','louky','lesy','rybniky','sady-vinice','zahrady','ostatni-pozemky']
        break
    case 'komercni':
        choices = ['kancelare','sklady','vyrobni-prostory','obchodni-prostory','ubytovani','restaurace','zemedelske-objekty','cinzovni-domy','ostatni-komercni-prostory']
        break
    case 'ostatni':
        choices = ['garaze','garazova-stani','mobilheimy','vinne-sklepy','pudni-prostory','jine-nemovitosti']
        break
    default:
        choices = ['N/A']
        break
}
return choices
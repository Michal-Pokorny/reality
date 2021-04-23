import json

def config_return_variable(var_name):
    file = open('config/config.json', encoding="utf-8")
    data = json.load(file)    
    return data[var_name]

def config_return_variable_list(list_name, var_name):
    file = open('config/config.json', encoding="utf-8")
    data = json.load(file)
    list = data[list_name]
    result = []
    for item in list:
        if var_name in item:
            result.append(item[var_name])            
    return result

def config_return_search_string(type, realty, location="all", size="all", optional=""):
    search_string = config_return_variable("search_base")
    search_string += "/" + type + "/" + realty
    if location != "all":
        search_string += "/" + location
    search_string += "?"
    if size != "all":
        search_string += "velikost=" + size + "&"
    if optional:
        search_string += optional
    else:
        search_string += config_return_variable("search_optional_default")       
    return search_string
        
        
            
        
            
        

    
    
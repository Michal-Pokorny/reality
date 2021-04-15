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
        

    
    
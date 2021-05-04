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

def config_return_search_string(type, realty, location="all", size="all", age="all", optional=""):
    search_string = config_return_variable("search_base")
    search_string += "/" + type + "/" + realty
    if location != "all":
        search_string += "/" + location
    search_string += "?"
    if size != "all":
        size = size.replace("+", "%2B")
        search_string += "velikost=" + size + "&"
    if age != "all":
        search_string += "stari=" + age + "&"
    if optional:
        search_string += optional       
    return search_string

def config_return_property_variable_list(var_name, type, realty):
    file = open('config/config.json', encoding="utf-8")
    data = json.load(file)
    list = data['property_variables']
    result = []
    for item in list:
        if var_name in item and type in item['type'] and realty in item['realty']:
            result.append(item[var_name])            
    return result

def return_variable_list_from_webelement_list(list, start, count):
    result = []
    end = count - 1
    for i in range(start, count):
        midresult = []
        for item in list:
            midresult.append(item[i])
        result.append(midresult)       
    return result    
    
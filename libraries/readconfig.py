import json
import datetime
from robot.libraries.BuiltIn import BuiltIn

def config_set_test_variables():
    file = open('config/config.json', encoding="utf-8")
    auctionplace = BuiltIn().get_variable_value("${auctionplace}")
    data = json.load(file)
    list = data[auctionplace]["test_variables"]
    for key in list.keys():
        val = list[key]
        var_name = "${" + key + "}"
        BuiltIn().set_test_variable(var_name, val)
    type = BuiltIn().get_variable_value("${search_type}")
    realty = BuiltIn().get_variable_value("${realty}")    
    BuiltIn().set_test_variable("${variable_header}", config_return_property_variable_list("name", type, realty, auctionplace))
    BuiltIn().set_test_variable("${variables_tags_list}", config_return_property_variable_list("locator", type, realty, auctionplace))
    BuiltIn().set_test_variable("${transformations_list}", config_return_transformations_list(type, realty, auctionplace))

def config_return_variable(var_name):
    file = open('config/config.json', encoding="utf-8")
    auctionplace = BuiltIn().get_variable_value("${auctionplace}")
    data = json.load(file)    
    return data[auctionplace][var_name]

def config_return_variable_list(list_name, var_name):
    file = open('config/config.json', encoding="utf-8")
    auctionplace = BuiltIn().get_variable_value("${auctionplace}")
    data = json.load(file)
    list = data[auctionplace][list_name]
    result = []
    for item in list:
        if var_name in item:
            result.append(item[var_name])            
    return result

def config_return_search_string(source, type, realty, location="all", size="all", age="all", optional=""):
    search_string = BuiltIn().get_variable_value("${search_base}")
    if source == "sreality":
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
    if source == "idnes":
        search_string += "/" + type + "/" + realty
        if size != "all":
            search_string += "/" + size
        if location != "all":
            search_string += "/" + location
        search_string += "?"
        if age != "all":
            if age == "den":
                age_string = "s-qc[articleAge]=1&"
            elif age == "tyden":
                age_string = "s-qc[articleAge]=7&"
            elif age == "mesic":
                age_string = "s-qc[articleAge]=31&"
            search_string += age_string           
        if optional:
            search_string += optional                            
    return search_string

def config_return_property_variable_list(var_name, type, realty, auctionplace):
    file = open('config/config.json', encoding="utf-8")
    data = json.load(file)
    list = data[auctionplace]['property_variables']
    result = []
    for item in list:
        if var_name in item and type in item['type'] and realty in item['realty']:
            result.append(item[var_name])            
    return result

def config_return_transformations_list(type, realty, auctionplace):
    file = open('config/config.json', encoding="utf-8")
    data = json.load(file)
    list = data[auctionplace]['property_variables']
    result = []
    i = 0
    for item in list:
        if type in item['type'] and realty in item['realty']:
            if "transformations" in item:
                for trans in item["transformations"]:
                    midresult = {}
                    midresult["id"] = i
                    midresult["effect"] = trans
                    result.append(midresult)
            i = i + 1                
    return result

def apply_transformations_to_result():
    transformation_list = BuiltIn().get_variable_value("${transformations_list}")
    result_data = BuiltIn().get_variable_value("${result_data}")
    for transformation in transformation_list:
        trans_id = transformation["id"]
        trans_eff = transformation["effect"]
        new_result_data = []
        for row in result_data:
            new_row = []
            i = 0
            for data in row:
                if trans_id == i:
                    new_data = apply_transformation_to_data(data, trans_eff)
                    new_row.append(new_data)
                else:
                    new_row.append(data)
                i = i + 1    
            new_result_data.append(new_row)                
        result_data = new_result_data           
    BuiltIn().set_test_variable("${result_data}", result_data)
    
def apply_transformation_to_data(data, trans):
    result = data
    if trans == "dnes_vcera":
        today = datetime.date.today()    
        if data == "Dnes":
            result = today.strftime("%d.%m.%Y")
        elif data == "Včera":
            yesterday = today - datetime.timedelta(days=1)
            result = yesterday.strftime("%d.%m.%Y")            
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
    
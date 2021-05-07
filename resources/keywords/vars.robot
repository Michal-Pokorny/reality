*** Settings ***
Library    String
Library    Collections
Library    OperatingSystem
Library    DateTime 
Library    Selenium2Library
Library    ../../libraries/csvlib.py
Library    ../../libraries/readconfig.py
Resource   ../variables.robot

*** Keywords ***
Set Test Variables from Parameters
    Config Set Test Variables
    Set Parametrized Search URL
    Set Parametrized Description
    Set Parametrized Search Limit
    
Set Parametrized Search URL
    ${search}=    Config Return Search String    ${auctionplace}    ${auction_type}    ${realty}    ${location}    ${size}    ${age}
    Set Test Variable    ${search_string}     ${search} 
    
Set Parametrized Description
    ${desc}=    Catenate    SEPARATOR=_    ${auctionplace}    ${auction_type}    ${realty}    ${location}    ${size}
    Set Test Variable    ${search_desc}     ${desc}    

Set Parametrized Search Limit
    Run Keyword If    ${search_limit} == 0    Set Test Variable    ${search_limit}    99999
    
Set Test Variables from Config
    ${config_url}=    Config Return Variable    url
    Set Test Variable    ${url}    ${config_url}
    ${config_variable_header}=    Return Property Variable Names
    Set Test Variable    ${variable_header}    ${config_variable_header}
    ${config_variables_tags_list}=    Return Property Variable Tags
    Set Test Variable    ${variables_tags_list}    ${config_variables_tags_list}
    
Set Constant Test Variables
    Set Test Variable    ${auctionplace}    idnes
    Set Test Variable    ${search_type}    fast
    Set Test Variable    ${search_limit}    2
    Set Test Variable    ${auction_type}    prodej
    Set Test Variable    ${realty}    byty
    Set Test Variable    ${location}    all
    Set Test Variable    ${size}    all
    Set Test Variable    ${age}    all
                 
Get Custom Timestamp
    ${timestamp}=    Get Current Date    result_format=${custom_timestamp}
    [return]    ${timestamp}
    
Set Custom Timestamp
    ${timestamp}=    Get Custom Timestamp
    Set Test Variable    ${starttime}    ${timestamp}            
    
Return Property Variable Tags
    ${variables_tags}=    Config Return Property Variable List    locator    ${search_type}    ${realty}
    [return]    ${variables_tags}
    
Return Property Variable Names
    ${variables_names}=    Config Return Property Variable List    name    ${search_type}    ${realty}
    [return]    ${variables_names}
    
Return Search Strings
    ${search_strings}=    Config Return Variable List    search    url
    [return]    ${search_strings}
    
Return Search Descriptions
    ${search_strings}=    Config Return Variable List    search    desc
    [return]    ${search_strings}
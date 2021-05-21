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
    
Set Constant Test Variables
    Set Test Variable    ${auctionplace}    sreality
    Set Test Variable    ${search_type}    fast
    Set Test Variable    ${search_limit}    1
    Set Test Variable    ${auction_type}    prodej
    Set Test Variable    ${realty}    byty
    Set Test Variable    ${location}    praha
    Set Test Variable    ${size}    1+1
    Set Test Variable    ${age}    all
                 
Get Custom Timestamp
    ${timestamp}=    Get Current Date    result_format=${custom_timestamp}
    [return]    ${timestamp}
    
Set Custom Timestamp
    ${timestamp}=    Get Custom Timestamp
    Set Test Variable    ${starttime}    ${timestamp}                
*** Settings ***
Library    String
Library    Collections
Library    OperatingSystem
Library    DateTime
Library    Selenium2Library
Library    ../libraries/csvlib.py
Library    ../libraries/readconfig.py
Test Setup    Open Browser with no Page
Test Teardown    Close Browser
Resource    ../resources/variables.robot
Resource    ../resources/keywords.robot                

*** Test Cases ***  
Save Parametrized Search
    [Tags]    Param
    Set Test Variables from Config
    Execute Parametrized Search and Save Into CSV
    
Save Test Parametrized Search
    [Tags]    Param_Test
    Set Custom Timestamp
    Set Test Variables from Config
    Set Constant Test Variables 
    Execute Parametrized Search and Save Into CSV
                  
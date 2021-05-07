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
Resource    ../resources/keywords/main.robot                

*** Test Cases ***    
Save Parametrized Direct Search
    [Tags]    Param
    Set Test Variables from Parameters
    Execute Parametrized Direct Search and Save Into CSV
    
Save Test Parametrized Direct Search
    [Tags]    Param_Test
    Set Custom Timestamp
    Set Constant Test Variables
    Set Test Variables from Parameters     
    Execute Parametrized Direct Search and Save Into CSV    
                  
*** Settings ***
Documentation    The tests are used to scrape data from Reality auctions and save them into .csv file.
...    The tests are using configuration file to provide them with necessary parameters
Test Setup    Open Browser with no Page
Test Teardown    Close Browser
Resource    ../resources/keywords/main.robot                

*** Test Cases ***    
Save Parametrized Direct Search
    [Tags]    Param
    [Documentation]    This test scrapes data based on the parameters it is ran with
    Set Test Variables from Parameters
    Execute Parametrized Direct Search and Save Into CSV
    
Save Test Parametrized Direct Search
    [Tags]    Param_Test
    [Documentation]    This test is used for development, test parameters are hard-coded
    Set Custom Timestamp
    Set Constant Test Variables
    Set Test Variables from Parameters     
    Execute Parametrized Direct Search and Save Into CSV    
                  
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
Save All Searched Links
    [Tags]    All
    ${starttime}=    Get Custom Timestamp
    Iterate All Searches and Save Into CSV    ${starttime}
    
Save Single Searched Link
    [Tags]    Single
    ${starttime}=    Get Custom Timestamp
    Execute Single Search and Save Into CSV    ${starttime}    0              
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
    ${starttime}=    Get Custom Timestamp
    Iterate All Searches and Save Into CSV    ${starttime}              
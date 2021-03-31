*** Settings ***
Library    String
Library    Collections
Library    Selenium2Library
Test Setup    Open Browser and go to Page
Test Teardown    Close Browser
Resource    ../resources/variables.robot
Resource    ../resources/keywords.robot                

*** Test Cases ***
Print All 1+KK Praha
    [Tags]  Print
    Print Text of All Elements with Tag    ${property_name_css}
    
Save All 1+KK Praha
    [Tags]  Save
    Save Text of All Elements with Tag    ${property_name_css}
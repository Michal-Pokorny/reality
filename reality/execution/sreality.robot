*** Settings ***
Library    String
Library    Collections
Library    OperatingSystem
Library    Selenium2Library
Library    CSVLibrary
Test Setup    Open Browser with no Page
Test Teardown    Close Browser
Resource    ../resources/variables.robot
Resource    ../resources/keywords.robot                

*** Test Cases ***
Print All Searched Links
    [Tags]  Print
    ${search_list}=    Iterate All Searched Pages and Return Links    ${search}    1
    Log List    ${search_list}
    ${variable_list}=    Iterate Pages from List and Return Variables    ${search_list}
    Log List    ${variable_list}
    Csv File From Associative    ${result_csv}    ${variable_list}
      
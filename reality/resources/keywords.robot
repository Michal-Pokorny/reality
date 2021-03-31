*** Settings ***
Library    String
Library    Collections
Library    OperatingSystem 
Library    Selenium2Library
Library    CSVLib
Library    CSVLibrary
Resource    variables.robot

*** Keywords ***
Open Browser and go to Page
    Open Browser    ${url}    ${browser}
    Maximize Browser Window
            
Return Text List from Element List    
    [arguments]    ${elements_tag}
    ${element_list}=    Get WebElements    ${elements_tag}
    ${element_count}=    Get Element Count    ${elements_tag}
    ${result_list}=    Create List
    FOR    ${i}    IN RANGE    0    ${element_count}
         ${current_element}=    Get From List    ${element_list}    ${i}
         ${text}=    Get Text    ${current_element}
         Append To List    ${result_list}    ${text}
    END
    [return]    ${result_list}
    
Print All Results
    [arguments]    ${result_list}
    FOR    ${result}    IN    @{result_list}
        Log    ${result}
    END

Save All Results
    [arguments]    ${list}
    Create File    ${result_csv}
    ${data}=    Create list    ${list}    
    Append To Csv File    ${result_csv}    ${data} 
    
Print Text of All Elements with Tag
    [arguments]    ${elements_tag}
    ${result_list}=    Return Text List from Element List    ${elements_tag}
    Print All Results    ${result_list}
    
Save Text of All Elements with Tag
    [arguments]    ${elements_tag}
    ${result_list}=    Return Text List from Element List    ${elements_tag}
    Save All Results    ${result_list}
    
Create URL with Page Number 
    [arguments]    ${url}    ${n}
    ${result_url}=    Catenate    ${url}    &strana=    ${n}
    [return]    ${result_url}                    
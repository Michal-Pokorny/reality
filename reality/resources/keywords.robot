*** Settings ***
Library    String
Library    Collections
Library    OperatingSystem 
Library    Selenium2Library
Library    CSVLibrary
Resource    variables.robot

*** Keywords ***
Open Browser and go to Page
    Set Screenshot Directory    screenshots
    Open Browser    ${url}    ${browser}
    Maximize Browser Window
    
Open Browser with no Page
    Set Screenshot Directory    screenshots
    Open Browser    about:blank    ${browser}
    Maximize Browser Window
   
Return nth searched page
    [arguments]    ${search}    ${n}
    ${url}=    Catenate    SEPARATOR=    ${url}    ${search}    &strana=    ${n}        
    [return]    ${url}    

Go to nth searched page
    [arguments]    ${search}    ${n}    ${element_tag}
    ${search_url}=    Return nth searched page    ${search}    ${n}    
    Go To    ${search_url}
    ${s}=    Convert to String    ${n}    
    Wait Until Element Contains    ${element_tag}    ${s}
    
Go to nth searched page and return count
    [arguments]    ${search}    ${n}    ${element_tag}    ${assert_tag}
    Go to nth searched page    ${search}    ${n}    ${element_tag}
    ${element_count}=    Get Element Count    ${assert_tag}
    [return]    ${element_count}        
     
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
    
Return Attribute List from Element List    
    [arguments]    ${elements_tag}    ${elements_attribute}    ${start}=0
    ${element_list}=    Get WebElements    ${elements_tag}
    ${result_list}=    Create List
    ${i}=    Set Variable    0    
    FOR    ${element}    IN    @{element_list}
        ${attribute}=    Get Element Attribute    ${element}    ${elements_attribute}
        Run Keyword If    ${i}>=${start}    Append To List    ${result_list}    ${attribute}
        ${i}=    Evaluate    ${i}+1    
    END
    [return]    ${result_list}
    
Print All Results
    [arguments]    ${result_list}    
    FOR    ${result}    IN    @{result_list}
        Log    ${result}
    END

Save List to CSV
    [arguments]    ${list}
    Create File    ${result_csv}    
    Append To Csv File    ${result_csv}    ${list}     
    
Get Total Pages
    [arguments]    ${search}    ${paging_total_tag}    ${paging_num}
    Go to nth searched page    ${search}    1    ${paging_current_css}
    ${paging_total_text}=    Get Text    ${paging_total_tag}
    ${paging_total_num}=    Convert to Integer    ${paging_total_text}
    ${paging_count}=    Evaluate    ${paging_total_num}/${paging_num}+0.5
    ${result}=    Convert to Integer    ${paging_count}
    [return]    ${result}
    
Iterate All Searched Pages and Return Links
    [arguments]    ${search}    ${max}
    ${page_count}=    Get Total Pages    ${search}    ${paging_count_css}    ${paging}
    ${result_list}=    Create List    
    FOR    ${i}    IN RANGE    ${page_count}-1
        ${n}=    Evaluate    ${i}+1
        Go to nth searched page    ${search}    ${n}    ${paging_current_css}
        ${midresult_list}=    Return Attribute List from Element List    ${property_link_css}    ${property_link_attribute}    1
        ${result_list}=    Combine Lists    ${result_list}    ${midresult_list}            
        Exit For Loop If    ${n} == ${max}
    END
    ${result_list}=    Remove Duplicates    ${result_list}
    [return]    ${result_list}
    
Iterate Pages from List and Return Variables
    [arguments]    ${search_list}
    ${property_list}=    Create List
    Append To List    ${property_list}    ${property_variables_names}
    FOR    ${search}    IN    @{search_list}
        ${search_url}=    Catenate    SEPARATOR=    ${url}    ${search}
        Go To    ${search_url}
        Wait Until Page Contains Element    ${property_assert_css}
        ${variables_list}=    Iterate Variables and Return List    ${property_variables_css}
        Append To List    ${variables_list}    ${search_url}    
        Append To List    ${property_list}    ${variables_list}       
    END
    [return]    ${property_list}
    
Iterate Variables and Return List
    [arguments]    ${variables_tags_list}
    ${variables_list}=    Create List    
    FOR    ${variable_tag}    IN    @{variables_tags_list}
        ${text}=    Get Text    ${variable_tag}
        Append To List    ${variables_list}    ${text}    
    END    
    [return]    ${variables_list}                            
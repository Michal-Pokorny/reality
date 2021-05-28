*** Settings ***
Documentation    Resource file containing high-level keywords for scraping data and saving it to csv
Library    String
Library    Collections
Library    OperatingSystem
Library    DateTime 
Library    Selenium2Library
Library    ../libraries/csvlib.py
Library    ../libraries/readconfig.py
Resource    ../variables/technical.robot
Resource    ../variables/runtime.robot
Resource    vars.robot
Resource    read.robot
Resource    nav.robot

*** Keywords ***                            
Return Attribute List from Element List    
    [arguments]    ${elements_tag}    ${elements_attribute}    ${start}=0
    ${element_list}=    Get WebElements    ${elements_tag}
    ${result_list}=    Create List
    ${element_count}=    Get Length    ${element_list}     
    FOR    ${i}    IN RANGE    0    ${element_count}
        ${element}=    Get From List    ${element_list}    ${i}
        ${attribute}=    Get Element Attribute    ${element}    ${elements_attribute}
        Run Keyword If    ${i}>=${start}    Append To List    ${result_list}    ${attribute}    
    END
    [return]    ${result_list}        
        
Check for Errors
    ${pass}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${property_assert_css}
    Run Keyword If    ${pass} == False    Log Error    ${error_css}     
    [return]    ${pass}
    
Log Error
    [arguments]    ${error_element}
    ${current_page}=    Get Location
    ${error_count}=    Get Element Count    ${error_element}
    Run Keyword If    ${error_count}>0    Log Error Message    ${current_page}    ${error_element}   
    Run Keyword If    ${error_count}==0    Log Timeout Error    ${current_page}
    
Log Error Message
    [arguments]    ${current_page}    ${error_element}
    ${error_text}=    Get Text    ${error_element}
    ${error_message}=    Catenate    ${current_page}    returned error:    ${error_text}
    Log    ${error_message}    WARN
    
Log Timeout Error
    [arguments]    ${current_page}
    ${error_message}=    Catenate    ${current_page}    did not load in time
    Log    ${error_message}    WARN                            

Save Search Result Into CSV
    ${result_path}=    Catenate    SEPARATOR=/    ${result_folder}    ${starttime}    
    ${result_csv}=    Catenate    SEPARATOR=    ${search_desc}    _    ${starttime}    .csv    
    Write Into Csv File    ${result_path}    ${result_csv}    ${variable_header}    ${result_data}
    ${log_message}=    Catenate    Saved data to    ${result_csv}    
    Log    ${log_message}    DEBUG    console=yes                 
        
Iterate Pages from List and Save Variables
    [arguments]    ${search_list}
    ${result_data_list}    Create List    
    FOR    ${search}    IN    @{search_list}
        ${search_url}=    Run Keyword If    '${url_full_transform}' == 'true'    Catenate    SEPARATOR=    ${url}    ${search}
        ...    ELSE    Catenate    ${search}
        Go To    ${search_url}
        ${pass}=    Check for Errors
        Continue For Loop If    ${pass} == False            
        ${variables_list}=    Return Property Variable List    ${search_url}            
        Append To List    ${result_data_list}    ${variables_list}
        ${log_message}=    Catenate    Saved variables from    ${search_url}    
        Log    ${log_message}    DEBUG    console=yes       
    END
    Set Test Variable    ${result_data}    ${result_data_list}
    
Execute Parametrized Direct Search and Save Into CSV
    Run Keyword If    '${search_type}' == 'fast'    Execute Fast Search and Save Data
    ...    ELSE    Execute Parametrized Direct Search and Save Data        
    Apply Transformations To Result
    Save Search Result Into CSV
    
Execute Parametrized Direct Search and Save Data
    ${link_list}=    Return Links of Direct Search
    Iterate Pages from List and Save Variables    ${link_list}
    
Execute Fast Search and Save Data
    ${result_data_list}    Create List
    FOR    ${i}    IN RANGE    0    ${search_limit}
        ${n}=    Evaluate    ${i}+${url_count_start}    
        ${count}=    Go To Nth Searched Page and Return Auction Count    ${n} 
        Exit For Loop If    ${count} == 0
        Continue For Loop If    ${count} == -1        
        ${start}=    Get Element Count    ${property_pinned_css}
        ${variable_list_page}=    Return Variables on Search Page    ${start}    ${count}
        ${result_data_list}=    Combine Lists    ${result_data_list}    ${variable_list_page}
        ${log_message}=    Catenate    Found    ${count}    properties on page    ${n}
        Log    ${log_message}    DEBUG    console=yes        
    END
    ${result_data_list}=    Remove Duplicates    ${result_data_list}
    Set Test Variable    ${result_data}    ${result_data_list}
    
Execute Fast
    FOR    ${i}    IN RANGE    0    ${search_limit}
        ${n}=    Evaluate    ${i}+1    
        ${count}=    Go To Nth Searched Page and Return Auction Count    ${n} 
        Exit For Loop If    ${count} == 0
        Continue For Loop If    ${count} == -1        
        ${log_message}=    Catenate    Found    ${count}    properties on page    ${n}
        Log    ${log_message}    DEBUG    console=yes        
    END    
    
Return Variables on Search Page
    [arguments]    ${start}    ${end}
    ${webelement_list}=    Return All Property Variables on Page
    ${link_list_page}=    Return Links on Page    0    ${end}
    ${transform_link_list_page}=    Run Keyword If    '${url_full_transform}' == 'true'    Transform Links to Full    ${link_list_page}   
    Run Keyword If    '${url_full_transform}' == 'true'    Append To List    ${webelement_list}    ${transform_link_list_page}
    ...    ELSE    Append To List    ${webelement_list}    ${link_list_page}        
    ${variable_list}=    Return Variable List From Webelement List    ${webelement_list}    ${start}    ${end}   
    [return]    ${variable_list}

Return Links of Direct Search
    ${link_list}=    Create List
    FOR    ${i}    IN RANGE    0    ${search_limit}
        ${n}=    Evaluate    ${i}+${url_count_start}    
        ${count}=    Go To Nth Searched Page and Return Auction Count    ${n} 
        Exit For Loop If    ${count} == 0
        Continue For Loop If    ${count} == -1 
        ${start}=    Get Element Count    ${property_pinned_css}
        ${link_list_page}=    Return Links on Page    ${start}    ${count}
        ${link_list}=    Combine Lists    ${link_list}    ${link_list_page}       
    END
    ${link_list}=    Remove Duplicates    ${link_list}
    ${link_count}=    Get Length    ${link_list}
    ${log_message}=    Catenate    Searched    ${n}    pages and found    ${link_count}    links    
    Log    ${log_message}    DEBUG    console=yes    
    [return]    ${link_list}       
    
Return Links on Page
    [arguments]    ${start}    ${end}
    ${link_list}=    Create List
    ${element_list}=    Get WebElements    ${property_link_css}
    FOR    ${i}    IN RANGE    ${start}    ${end}
        ${element}=    Get From List    ${element_list}    ${i}
        ${attribute}=    Get Element Attribute    ${element}    ${property_link_attribute}
        Append To List    ${link_list}    ${attribute}        
    END
    [return]    ${link_list}
    
Transform Links to Full
    [arguments]    ${link_list}
    ${link_list_result}=    Create List
    FOR    ${link}    IN    @{link_list}
        ${link_result}=    Catenate    SEPARATOR=    ${url}    ${link}
        Append to List    ${link_list_result}    ${link_result}
    END
    [return]    ${link_list_result}    
    
Go To Nth Searched Page and Return Auction Count
    [arguments]    ${i}
    Go To Nth Searched Page    ${i}
    ${pass}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${page_assert_css}
    ${n}=    Run Keyword If    ${pass} == True    Get Element Count    ${property_link_css}
    ...    ELSE    Log Failed Page Load
    [return]    ${n} 
    
Log Failed Page Load
    ${current_page}=    Get Location
    ${log_message}=    Catenate    ${current_page}    did not load in    ${timeout}    seconds. Skipping.
    Log    ${log_message}    WARN    console=yes
    ${error_count}=    Evaluate    ${error_count} + 1
    Run Keyword If    ${error_count} > ${error_limit}    Fatal Error    
    [return]    -1
    

    

                                   
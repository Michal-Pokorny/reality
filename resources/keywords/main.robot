*** Settings ***
Library    String
Library    Collections
Library    OperatingSystem
Library    DateTime 
Library    Selenium2Library
Library    Process
Library    ../../libraries/csvlib.py
Library    ../../libraries/readconfig.py
Resource    ../variables.robot
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
    
Go to 1st Page and Return Total Pages
    ${pass}=    Go to nth searched page and Assert    1
    Log    ${pass}
    ${total_pages}=    Run Keyword If    ${pass} == True    Get Total Pages
    ...    ELSE    Evaluate    1
    [return]    ${total_pages}        

Get Total Pages    
    ${paging_total_text}=    Get Text    ${paging_count_css}
    ${paging_total_num}=    Convert to Integer    ${paging_total_text}
    ${paging_count}=    Evaluate    ${paging_total_num}/${paging}+0.99
    ${result}=    Convert to Integer    ${paging_count}
    [return]    ${result}
    
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

Execute Parametrized Search and Save Into CSV    
    ${search_list}=    Iterate All Searched Pages and Return Links
    ${variable_list}=    Iterate Pages from List and Return Variables    ${search_list}        
    Save Search Result Into CSV    ${variable_list}      

Save Search Result Into CSV
    [arguments]    ${variable_list}
    ${result_path}=    Catenate    SEPARATOR=/    ${result_folder}    ${starttime}    
    ${result_csv}=    Catenate    SEPARATOR=    ${search_desc}    _    ${starttime}    .csv    
    Write Into Csv File    ${result_path}    ${result_csv}    ${variable_header}    ${variable_list}
    ${log_message}=    Catenate    Saved data to    ${result_csv}    
    Log    ${log_message}    DEBUG    console=yes                 
    
Iterate All Searched Pages and Return Links
    ${page_count}=    Go to 1st Page and Return Total Pages   
    ${result_list}=    Create List    
    FOR    ${i}    IN RANGE    0    ${page_count}
        ${n}=    Evaluate    ${i}+1
        Go to nth searched page and Assert    ${n}
        ${midresult_list}=    Return Attribute List from Element List    ${property_link_css}    ${property_link_attribute}    1
        ${result_list}=    Combine Lists    ${result_list}    ${midresult_list}            
        Exit For Loop If    ${n} == ${search_limit}
        Log    ${n}    DEBUG    console=yes
        Log    ${midresult_list}    DEBUG    console=yes
    END
    ${result_list}=    Remove Duplicates    ${result_list}
    [return]    ${result_list}
    
Iterate Pages from List and Return Variables
    [arguments]    ${search_list}
    ${property_list}=    Create List    
    FOR    ${search}    IN    @{search_list}
        ${search_url}=    Catenate    SEPARATOR=    ${url}    ${search}
        Go To    ${search_url}
        ${pass}=    Check for Errors
        Continue For Loop If    ${pass} == False            
        ${variables_list}=    Return Property Variable List    ${search_url}            
        Append To List    ${property_list}    ${variables_list}       
    END
    [return]    ${property_list}
    
Execute Parametrized Direct Search and Save Into CSV
    ${data}=    Run Keyword If    '${search_type}' == 'fast'    Execute Fast Search and Return Data
    ...    ELSE    Execute Parametrized Direct Search and Return Data        
    Save Search Result Into CSV    ${data}
    
Execute Parametrized Direct Search and Return Data
    ${link_list}=    Return Links of Direct Search
    ${variable_list}=    Iterate Pages from List and Return Variables    ${link_list}
    [return]    ${variable_list}
    
Execute Fast Search and Return Data
    ${variable_list}=    Create List
    FOR    ${i}    IN RANGE    0    ${search_limit}
        ${n}=    Evaluate    ${i}+1    
        ${count}=    Go To Nth Searched Page and Return Auction Count    ${n} 
        Exit For Loop If    ${count} == 0
        Continue For Loop If    ${count} == -1        
        ${start}=    Get Element Count    ${property_pinned_css}
        ${variable_list_page}=    Return Variables on Search Page    ${start}    ${count}
        ${variable_list}=    Combine Lists    ${variable_list}    ${variable_list_page}
        ${log_message}=    Catenate    Found    ${count}    properties on page    ${n}
        Log    ${log_message}    DEBUG    console=yes        
    END
    [return]    ${variable_list}
    
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
    ${full_link_list}=    Transform Links to Full    ${link_list_page}
    Append To List    ${webelement_list}    ${full_link_list}    
    ${variable_list}=    Return Variable List From Webelement List    ${webelement_list}    ${start}    ${end}   
    [return]    ${variable_list}

Return Links of Direct Search
    ${link_list}=    Create List
    FOR    ${i}    IN RANGE    0    ${search_limit}
        ${n}=    Evaluate    ${i}+1    
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
    ${log_message}=    Catenate    ${current_page}    did not load in 30 seconds. Skipping.
    Log    ${log_message}    WARN    console=yes
    ${error_count}=    Evaluate    ${error_count} + 1
    Run Keyword If    ${error_count} > ${error_limit}    Terminate Process    
    [return]    -1
    

    

                                   
*** Settings ***
Library    String
Library    Collections
Library    OperatingSystem
Library    DateTime 
Library    Selenium2Library
Library    ../libraries/csvlib.py
Library    ../libraries/readconfig.py
Resource    variables.robot

*** Keywords ***
Open Browser with no Page
    ${chrome_options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    test-type
    Call Method    ${chrome_options}    add_argument    --disable-extensions
    Call Method    ${chrome_options}    add_argument    --headless
    Call Method    ${chrome_options}    add_argument    --disable-gpu
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    Create Webdriver    Chrome    chrome_options=${chrome_options}
    Set Screenshot Directory    screenshots
    Maximize Browser Window           
   
Return nth searched page
    [arguments]    ${search}    ${n}
    ${url_result}=    Catenate    SEPARATOR=    ${url}    ${search}    &strana=    ${n}        
    [return]    ${url_result}    

Go to nth searched page
    [arguments]    ${search}    ${n}    ${element_tag}
    ${search_url}=    Return nth searched page    ${search}    ${n}    
    Go To    ${search_url}
    ${s}=    Convert to String    ${n}    
    Wait Until Element Contains    ${element_tag}    ${s}            
         
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
    
Get Total Pages
    [arguments]    ${search}    ${paging_total_tag}    ${paging_num}
    Go to nth searched page    ${search}    1    ${paging_current_css}
    ${paging_total_text}=    Get Text    ${paging_total_tag}
    ${paging_total_num}=    Convert to Integer    ${paging_total_text}
    ${paging_count}=    Evaluate    ${paging_total_num}/${paging_num}+0.99
    ${result}=    Convert to Integer    ${paging_count}
    [return]    ${result}
    
Check for Errors
    ${pass}=    Run Keyword and Ignore Error    Wait Until Page Contains Element    ${property_assert_css}
    Run Keyword If    ${pass}=='false'    Log Error    ${error_css}     
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

Iterate All Searches and Save Into CSV
    ${search_url_list}=    Return Search Strings
    ${search_desc_list}=    Return Search Descriptions
    ${search_count}=    Get Length    ${search_url_list}            
    FOR    ${i}    IN RANGE    ${search_count}
        ${search}=    Get From List    ${search_url_list}    ${i}
        ${search_desc}=    Get From List    ${search_desc_list}    ${i}        
        ${search_list}=    Iterate All Searched Pages and Return Links    ${search}
        ${variable_list}=    Iterate Pages from List and Return Variables    ${search_list}        
        Save Search Result Into CSV    ${search_desc}    ${variable_list}                
    END
    
Execute Single Search and Save Into CSV
    [arguments]    ${i}
    ${search_url_list}=    Return Search Strings
    ${search_desc_list}=    Return Search Descriptions
    ${search_count}=    Get Length    ${search_url_list}            
    ${search}=    Get From List    ${search_url_list}    ${i}
    ${search_desc}=    Get From List    ${search_desc_list}    ${i}        
    ${search_list}=    Iterate All Searched Pages and Return Links    ${search}
    ${variable_list}=    Iterate Pages from List and Return Variables    ${search_list}        
    Save Search Result Into CSV    ${search_desc}    ${variable_list}                      

Execute Parametrized Search and Save Into CSV
    ${search}=    Return Parametrized Search URL
    ${search_desc}=    Return Parametrized Description    
    ${search_list}=    Iterate All Searched Pages and Return Links    ${search}
    ${variable_list}=    Iterate Pages from List and Return Variables    ${search_list}        
    Save Search Result Into CSV    ${search_desc}    ${variable_list}   

Return Parametrized Search URL
    ${search}    Config Return Search String    ${auction_type}    ${realty}    ${location}    ${size}
    [return]    ${search}
    
Return Parametrized Description
    ${desc}=    Catenate    SEPARATOR=_    ${auction_type}    ${realty}    ${location}    ${size}
    [return]    ${desc}   

Save Search Result Into CSV
    [arguments]    ${search_desc}    ${variable_list}
    ${result_path}=    Config Return Variable    result_path
    ${result_csv}=    Catenate    SEPARATOR=    ${search_desc}    _    ${starttime}    .csv    
    Write Into Csv File    ${result_path}    ${result_csv}    ${variable_header}    ${variable_list}                
    
Iterate All Searched Pages and Return Links
    [arguments]    ${search}
    ${page_count}=    Get Total Pages    ${search}    ${paging_count_css}    ${paging}
    ${result_list}=    Create List    
    FOR    ${i}    IN RANGE    0    ${page_count}
        ${n}=    Evaluate    ${i}+1
        Go to nth searched page    ${search}    ${n}    ${paging_current_css}
        ${midresult_list}=    Return Attribute List from Element List    ${property_link_css}    ${property_link_attribute}    1
        ${result_list}=    Combine Lists    ${result_list}    ${midresult_list}            
        Exit For Loop If    ${n} == ${search_limit}
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
        Continue For Loop If    ${pass}=='false'            
        ${variables_list}=    Return Property Variable List    ${search_url}            
        Append To List    ${property_list}    ${variables_list}       
    END
    [return]    ${property_list}
    
Return Property Variable List
    [arguments]    ${search_url}
    ${variables_list}=    Iterate Variables and Return List
    Append To List    ${variables_list}    ${search_url}
    [return]    ${variables_list} 
    
Iterate Variables and Return List
    ${variables_list}=    Create List    
    FOR    ${variable_tag}    IN    @{variables_tags_list}
        ${text_count}=    Get Element Count    ${variable_tag} 
        ${text}= 	Run Keyword If 	${text_count} > 0 	Get Text or Checkmark    ${variable_tag} 		
        ... 	ELSE    Set Variable                                 
        Append To List    ${variables_list}    ${text}    
    END    
    [return]    ${variables_list}
    
Get Text or Checkmark
    [arguments]    ${variable_tag}
    ${text}=    Get Text    ${variable_tag}
    ${length}=    Get Length    ${text}
    ${text}=    Run Keyword If    ${length} == 0    Return Checkmark Value    ${variable_tag}
    ...    ELSE    Set Variable    ${text}
    [return]    ${text}
    
Return Checkmark Value
    [arguments]    ${variable_tag}
    ${variable_tag_ok}=    Catenate    SEPARATOR=    ${variable_tag}    /span[@class='icof icon-ok ng-scope']
    ${tag_ok_count}=    Get Element Count    ${variable_tag_ok}
    ${variable_tag_cross}=    Catenate    SEPARATOR=    ${variable_tag}    /span[@class='icof icon-cross ng-scope']
    ${tag_cross_count}=    Get Element Count    ${variable_tag_cross}
    ${checkmark_value}=    Set Variable If    ${tag_ok_count}>0    True
    ...    ${tag_cross_count}>0    False
    [return]    ${checkmark_value}
    
Set Test Variables from Config
    ${config_url}=    Config Return Variable    url
    Set Test Variable    ${url}    ${config_url}
    ${config_search_limit}=    Config Return Variable    search_limit
    Set Test Variable    ${search_limit}    ${config_search_limit}
    ${config_variable_header}=    Return Property Variable Names
    Set Test Variable    ${variable_header}    ${config_variable_header}
    ${config_variables_tags_list}=    Return Property Variable Tags
    Set Test Variable    ${variables_tags_list}    ${config_variables_tags_list}                 

Get Custom Timestamp
    ${custom_timestamp}=    Config Return Variable    custom_timestamp
    ${timestamp}=    Get Current Date    result_format=${custom_timestamp}
    [return]    ${timestamp}
    
Set Custom Timestamp
    ${timestamp}=    Get Custom Timestamp
    Set Test Variable    ${starttime}    ${timestamp}            
    
Return Property Variable Tags
    ${variables_tags}=    Config Return Variable List    property_variables    locator
    [return]    ${variables_tags}
    
Return Property Variable Names
    ${variables_tags}=    Config Return Variable List    property_variables    name
    [return]    ${variables_tags}
    
Return Search Strings
    ${search_strings}=    Config Return Variable List    search    url
    [return]    ${search_strings}
    
Return Search Descriptions
    ${search_strings}=    Config Return Variable List    search    desc
    [return]    ${search_strings}
                                   
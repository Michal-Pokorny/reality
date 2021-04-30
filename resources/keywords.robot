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
    [arguments]    ${search}    ${n}
    ${search_url}=    Return nth searched page    ${search}    ${n}    
    Go To    ${search_url}
    ${pass}=    Run Keyword If    ${n}==1    Wait Until 1st Page Is Loaded
    ...    ELSE    Wait Until Nth Page is Loaded    ${n}
    [return]    ${pass}    
    
Wait Until 1st Page Is Loaded
    ${pass}=    Run Keyword And Return Status    Wait Until Element Contains    ${paging_current_css}    1
    Run Keyword If    ${pass} == False    Wait Until Page Contains Element    ${page_assert_css}
    [return]    ${pass}
    
Wait Until Nth Page is Loaded
    [arguments]    ${n}
    ${s}=    Convert to String    ${n}
    ${pass}=    Run Keyword And Return Status    Wait Until Element Contains    ${paging_current_css}    ${s}
    [return]    ${pass}
                    
         
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
    [arguments]    ${search}
    ${pass}=    Go to nth searched page    ${search}    1
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
    ${search}=    Return Parametrized Search URL
    ${search_desc}=    Return Parametrized Description    
    ${search_list}=    Iterate All Searched Pages and Return Links    ${search}
    ${variable_list}=    Iterate Pages from List and Return Variables    ${search_list}        
    Save Search Result Into CSV    ${search_desc}    ${variable_list}   

Return Parametrized Search URL
    ${search}    Config Return Search String    ${auction_type}    ${realty}    ${location}    ${size}    ${age}
    [return]    ${search}
    
Return Parametrized Description
    ${desc}=    Catenate    SEPARATOR=_    ${auction_type}    ${realty}    ${location}    ${size}
    [return]    ${desc}   

Save Search Result Into CSV
    [arguments]    ${search_desc}    ${variable_list}
    ${result_path}=    Catenate    SEPARATOR=/    ${result_folder}    ${starttime}    
    ${result_csv}=    Catenate    SEPARATOR=    ${search_desc}    _    ${starttime}    .csv    
    Write Into Csv File    ${result_path}    ${result_csv}    ${variable_header}    ${variable_list}                
    
Iterate All Searched Pages and Return Links
    [arguments]    ${search}
    ${page_count}=    Go to 1st Page and Return Total Pages    ${search}    
    ${result_list}=    Create List    
    FOR    ${i}    IN RANGE    0    ${page_count}
        ${n}=    Evaluate    ${i}+1
        Go to nth searched page    ${search}    ${n}
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
        Continue For Loop If    ${pass} == False            
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
    ${config_variable_header}=    Return Property Variable Names
    Set Test Variable    ${variable_header}    ${config_variable_header}
    ${config_variables_tags_list}=    Return Property Variable Tags
    Set Test Variable    ${variables_tags_list}    ${config_variables_tags_list}
    
Set Constant Test Variables
    Set Test Variable    ${search_type}    basic
    Set Test Variable    ${search_limit}    2
    Set Test Variable    ${auction_type}    prodej
    Set Test Variable    ${realty}    byty
    Set Test Variable    ${location}    karlovarsky-kraj
    Set Test Variable    ${size}    6-a-vice
    Set Test Variable    ${age}    all
                 
Get Custom Timestamp
    ${custom_timestamp}=    Config Return Variable    custom_timestamp
    ${timestamp}=    Get Current Date    result_format=${custom_timestamp}
    [return]    ${timestamp}
    
Set Custom Timestamp
    ${timestamp}=    Get Custom Timestamp
    Set Test Variable    ${starttime}    ${timestamp}            
    
Return Property Variable Tags
    ${variables_tags}=    Config Return Property Variable List    locator    ${search_type}    ${realty}
    [return]    ${variables_tags}
    
Return Property Variable Names
    ${variables_names}=    Config Return Property Variable List    name    ${search_type}    ${realty}
    [return]    ${variables_names}
    
Return Search Strings
    ${search_strings}=    Config Return Variable List    search    url
    [return]    ${search_strings}
    
Return Search Descriptions
    ${search_strings}=    Config Return Variable List    search    desc
    [return]    ${search_strings}
                                   
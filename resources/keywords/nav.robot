*** Settings ***
Library    String
Library    Collections
Library    OperatingSystem
Library    DateTime 
Library    Selenium2Library
Library    ../../libraries/csvlib.py
Library    ../../libraries/readconfig.py
Resource   ../variables.robot

*** Keywords ***
Open Browser with no Page
    ${chrome_options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    test-type
    Call Method    ${chrome_options}    add_argument    --disable-extensions
    Call Method    ${chrome_options}    add_argument    --headless
    Call Method    ${chrome_options}    add_argument    --disable-gpu
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    Call Method    ${chrome_options}    add_argument    --disable-dev-shm-usage
    Create Webdriver    Chrome    chrome_options=${chrome_options}
    Set Screenshot Directory    screenshots
    Maximize Browser Window
    Set Selenium Timeout 	30 seconds
    
Open Browser with no Page Test
    ${chrome_options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    --headless
    Call Method    ${chrome_options}    add_argument    --disable-gpu
    Create Webdriver    Chrome    chrome_options=${chrome_options} 
    Set Screenshot Directory    screenshots
    
Reset Browser
    Close Browser
    Sleep    5s
    Open Browser with no Page           
   
Return nth searched page
    [arguments]    ${n}
    ${url_result}=    Catenate    SEPARATOR=    ${url}    ${search_string}    &strana=    ${n}        
    [return]    ${url_result}    

Go To Nth Searched Page
    [arguments]    ${n}
    ${search_url}=    Return nth searched page    ${n}    
    Go To    ${search_url}

Go to nth searched page and Assert
    [arguments]    ${n}
    ${search_url}=    Return nth searched page    ${n}    
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
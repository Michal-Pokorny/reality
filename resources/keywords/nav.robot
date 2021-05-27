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
    Log    ${engine}
    Run Keyword If    '${engine} == windows'    Open Chrome with no Page
    ...    ELSE    Open Firefox with no Page

Open Chrome with no Page
    ${chrome_options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    test-type
    Call Method    ${chrome_options}    add_argument    --disable-extensions
    Call Method    ${chrome_options}    add_argument    --headless
    Call Method    ${chrome_options}    add_argument    --disable-gpu
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    Call Method    ${chrome_options}    add_argument    --disable-dev-shm-usage
    Call Method    ${chrome_options}    add_argument    --user-agent\=Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.95 Safari/537.36 System/ComputerId
    Create Webdriver    Chrome    chrome_options=${chrome_options}
    Set Screenshot Directory    screenshots
    Maximize Browser Window
    Set Selenium Timeout 	${timeout}
    
Open Firefox with no Page
    Open Browser    about:blank    headlessfirefox
    Set Screenshot Directory    screenshots
    Maximize Browser Window
    Set Selenium Timeout 	${timeout}    
    
Reset Browser
    Close Browser
    Open Browser with no Page           
   
Return Nth searched page
    [arguments]    ${n}
    ${url_result}=    Catenate    SEPARATOR=    ${url}    ${search_string}    &    ${url_count_string}    ${n}        
    [return]    ${url_result}    

Go To Nth Searched Page
    [arguments]    ${n}
    ${search_url}=    Return Nth searched page    ${n}    
    Go To    ${search_url}
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
    
Return All Property Variables on Page
    ${text_list}=    Create List
    FOR    ${variable_tag}    IN    @{variables_tags_list}
        ${webelement_sublist}=    Get WebElements    ${variable_tag}
        ${text_sublist}=    Get Texts For Webelements    ${webelement_sublist}    
        Append To List    ${text_list}    ${text_sublist}
    END
    [return]    ${text_list}
    
Get Texts For Webelements
    [arguments]    ${webelement_list}
    ${text_list}=    Create List
    FOR    ${webelement}    IN    @{webelement_list}
        ${text}=    Get Text    ${webelement}
        Append To List    ${text_list}    ${text}    
    END
    [return]    ${text_list}    
    
Get Text or Checkmark
    [arguments]    ${variable_tag}
    Wait Until Element Is Visible    ${variable_tag}    
    ${text}=    Get Element Attribute    ${variable_tag}    innerHTML
    ${length}=    Get Length    ${text}    
    #${length}=    Run Keyword If    ${text} != None    Get Length    ${text}
    #...    ELSE    Set Variable    1
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
*** Settings ***
Resource     ../../../../Resources/CreateOrderKeyword.robot
Library     ../../../../Resources/read_write_all_excel.py
Resource     ../../../../Resources/createSession.robot
Library    ../../../../Resources/Prepare_Xml_Content.py
Library           DateTime


*** Variables ***

*** Test Cases ***
Manage Item TC_001
    [Tags]      HAPPYFLOW    MANAGEITEM
    Log To Console    ${CURDIR}
     Log To Console    '************************************************8*******'
    Creating Session1        AddData
    ${jsonContent}=     Manage Item With Dynamic Item    ${CURDIR}
    ${response}=     Post On Session     AddData   ${base_url_api}${manageItem}     data=${jsonContent}    headers=${headers}
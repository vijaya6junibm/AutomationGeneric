*** Settings ***
Resource     ../../../Resources/CreateOrderKeyword.robot
Library     ../../../Resources/read_write_all_excel.py
Resource    ../../../Resources/createSession.robot
Library    ../../../Resources/Prepare_Xml_Content.py
Library           DateTime
Library              OperatingSystem


*** Variables ***

*** Test Cases ***
TC_008
    [Documentation]  EPLFlashStoreLoadSyncService with existing shipnode but different zipcode 52977 (zipcode doesn’t exist in table )combination in extnFlashStore table (98047 exists)
    [Tags]      REGRESSION    EPLFlashStoreLoadSyncService
    Creating Session1     AddData
    ${sfLoadJson}=     Input File1    ${CURDIR}
    ${response}=     Post On Session     AddData   ${base_url_flow}${EPLFlashStoreLoadSyncService}     data=${sfLoadJson}
    Log To Console    ${response.json()}
    Dictionary Should Contain Key     ${response.json()}     ZipCode
         ${Flash_Store_Key}=    Get From Dictionary     ${response.json()}    ZipCode
         log  ${Flash_Store_Key}
         Dictionary Should Contain Key     ${response.json()}     ShipNode
         ${Ship_Node}=    Get From Dictionary     ${response.json()}    ShipNode
         log  ${Ship_Node}
         Set Test Message    New record created in extn_flash_store table
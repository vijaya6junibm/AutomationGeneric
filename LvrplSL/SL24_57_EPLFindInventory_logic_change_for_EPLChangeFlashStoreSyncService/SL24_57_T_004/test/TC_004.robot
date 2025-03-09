*** Settings ***
Resource     ../../../Resources/CreateOrderKeyword.robot
Library     ../../../Resources/read_write_all_excel.py
Resource    ../../../Resources/createSession.robot
Library    ../../../Resources/Prepare_Xml_Content.py
Library           DateTime
Library              OperatingSystem


*** Variables ***

*** Test Cases ***
TC_004
    [Documentation]  EPLFlashStoreLoadSyncService with existing zipcode and shipnode combination in extn_flash_store table
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
         Set Test Message    Record is updated no error thrown
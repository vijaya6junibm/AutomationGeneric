*** Settings ***
Resource     ../../../Resources/CreateOrderKeyword.robot
Library     ../../../Resources/read_write_all_excel.py
Resource    ../../../Resources/createSession.robot
Library    ../../../Resources/Prepare_Xml_Content.py
Library           DateTime
Library              OperatingSystem


*** Variables ***

*** Test Cases ***
Create Order TC_001
    [Tags]      REGRESSION    ePLCreateFlashStoreSyncService
    Creating Session1     AddData
    ${sfLoadJson}=     Input File1    ${CURDIR}
    ${response}=     Post On Session     AddData   ${base_url_flow}${ePLCreateFlashStoreSyncService}     data=${sfLoadJson}
    Dictionary Should Contain Key     ${response.json()}     FlashStoreKey
         ${Flash_Store_Key}=    Get From Dictionary     ${response.json()}    FlashStoreKey
         log  ${Flash_Store_Key}
         Dictionary Should Contain Key     ${response.json()}     ShipNode
         ${Ship_Node}=    Get From Dictionary     ${response.json()}    ShipNode
         log  ${Ship_Node}
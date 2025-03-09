*** Settings ***
Resource     ../../../Resources/CreateOrderKeyword.robot
Library     ../../../Resources/read_write_all_excel.py
Resource    ../../../Resources/createSession.robot
Library    ../../../Resources/Prepare_Xml_Content.py
Library           DateTime
Library              OperatingSystem


*** Variables ***

*** Test Cases ***
TC_002
    [Documentation]  findInventory call inventory available in shipnode:127 (multiapi)
    [Tags]      REGRESSION    EPLFlashStoreLoadSyncService
    Creating Session1     AddData
    ${manageItemJson}=     Manage Item With Dynamic Item        ${CURDIR}
    ${manageItemResponse}=     Post On Session     AddData   ${base_url_api}${manageItem}     data=${manageItemJson}
    status should be       204     ${manageItemResponse}
    ${jsonItemId}=     Manage Item With Dynamic Item1    ${CURDIR}
    Dictionary Should Contain Key     ${jsonItemId}     ItemList
         ${Item_ID_Path}=    Get From Dictionary     ${jsonItemId}    ItemList
         ${jsonAdjInv}=     Adjust Inventory File          ${jsonItemId}[ItemList][Item][_ItemID]    ${CURDIR}
    ${adjInvresponse}=     Post On Session     AddData   ${base_url_api}${adjustInventory}     data=${jsonAdjInv}    headers=${headers}
    status should be       204     ${adjInvresponse}
         ${jsonfindInventory}=     Find Inventory File       ${jsonItemId}[ItemList][Item][_ItemID]    ${CURDIR}
    ${findInventoryResponse}=     Post On Session     AddData   ${base_url_api}${multiApi}     data=${jsonfindInventory}    headers=${headers}
    Log To Console    ${findInventoryResponse.json()}
    ${resp}=    convert to string   ${findInventoryResponse.json()}
    Write Output File       ${resp}        'findInv'    ${CURDIR}
    Dictionary Should Contain Key     ${findInventoryResponse.json()}     API
         ${api}=    Get From Dictionary     ${findInventoryResponse.json()}    API
          ${Output}=    Get From Dictionary     ${api}    Output
          ${Promise}=    Get From Dictionary     ${Output}    Promise
         ${Order_No}=    Get From Dictionary     ${Promise}    SuggestedOption
         ${Option}  Get From Dictionary  ${Order_No}  Option
          ${PromiseLines}  Get From Dictionary  ${Option}  PromiseLines
         ${PromiseLine}  Get From Dictionary  ${PromiseLines}  PromiseLine
          ${AssignmentsList}  Get From List  ${PromiseLine}  0
          ${assignments}  Get From Dictionary  ${AssignmentsList}  Assignments
          ${assignment}  Get From Dictionary  ${Assignments}  Assignment
         ${assignmentList}  Get From List  ${assignment}  0
         ${ShipNode}  Get From Dictionary  ${assignmentList}  ShipNode
         Log    ${ShipNode}
         Set Test Message    ShipNode 127 suggested in Assignment ShipNode from response is ${ShipNode}

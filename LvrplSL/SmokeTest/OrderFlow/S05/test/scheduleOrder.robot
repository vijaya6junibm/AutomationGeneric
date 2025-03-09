*** Settings ***
Resource     ../../../../Resources/CreateOrderKeyword.robot
Library     ../../../../Resources/read_write_all_excel.py
Resource     ../../../../Resources/createSession.robot
Library    ../../../../Resources/Prepare_Xml_Content.py
Library           DateTime
Library              OperatingSystem


*** Variables ***

*** Test Cases ***
Schedule Order TC_001
    [Tags]      HAPPYFLOW    SCHEDULEORDER
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
    ${findInventoryResponse}=     Post On Session     AddData   ${base_url_api}${findInventory}     data=${jsonfindInventory}    headers=${headers}
    ${resp}=    convert to string   ${findInventoryResponse.json()}
    Write Output File       ${resp}        'findInv'    ${CURDIR}
    ${jsonCreateOrder}=     Create Order File      ${jsonItemId}[ItemList][Item][_ItemID]    ${CURDIR}
    ${createOrderResponse}=     Post On Session     AddData   ${base_url_api}${createOrder}     data=${jsonCreateOrder}    headers=${headers}
    ${resp2}=    convert to string   ${createOrderResponse.json()}
    Write Output File       ${resp2}        'createOrder'        ${CURDIR}
    Log To Console    ${createOrderResponse}
    ${timestamp} =    Get Current Date    result_format=%Y%m%d-%H%M
         Dictionary Should Contain Key     ${createOrderResponse.json()}     OrderNo
         ${Order_No}=    Get From Dictionary     ${createOrderResponse.json()}    OrderNo
         Dictionary Should Contain Key     ${createOrderResponse.json()}     OrderHeaderKey
         ${Order_Header_Key}=    Get From Dictionary     ${createOrderResponse.json()}    OrderHeaderKey
         Append Excel File1  ${file}    ${Order_No}     ${TEST NAME}    ${timestamp}    ${jsonCreateOrder}     ${createOrderResponse.json()}

         ${Order_No1}=    Schedule Input File1     ${Order_No}     ${Order_Header_Key}     ${CURDIR}
    ${response1}=     Post On Session     AddData   ${base_url_api}${scheduleOrder}     data=${Order_No1}    headers=${headers}

    ${Order_No2}=    GetOrderDetails Input File1     ${Order_No}     ${Order_Header_Key}     ${CURDIR}
    ${response1}=     Post On Session     AddData   ${base_url_api}${getOrderDetails}     data=${Order_No2}    headers=${headers}
     ${resp1}=    convert to string   ${response1.json()}
     Write Output File       ${resp2}        ${getOrderDetails}        ${CURDIR}
    Log To Console        'b7 getOrderDetails'
    Dictionary Should Contain Key     ${response1.json()}     Status
         ${Order_Status}=    Get From Dictionary     ${response1.json()}    Status
         ${values}=     Get Value From Json    ${response1.json()}    $..ItemID
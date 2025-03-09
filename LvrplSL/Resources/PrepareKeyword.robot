*** Settings ***
Library       Collections
Library       RequestsLibrary
Library     ../Resources/Create_Order_Xml_Content.py
Library      JSONLibrary
Library    ../Resources/Prepare_Xml_Content.py
Resource     ../Resources/CreateOrderKeyword.robot
Library    ../Resources/connectToDb.py
Library           DateTime
Library    XML
Library    BuiltIn
Library  DatabaseLibrary
Library     ../Resources/read_write_all_excel.py

*** Keywords ***
Manage Item
    [Arguments]         ${CUR_DIR}
    ${manageItemJson}=     Manage Item With Dynamic Item        ${CUR_DIR}
    ${manageItemResponse}=     Post On Session     AddData   ${base_url_api}${manageItem}     data=${manageItemJson}
    status should be       204     ${manageItemResponse}
    ${jsonItemId}=     Manage Item With Dynamic Item1    ${CUR_DIR}
    Dictionary Should Contain Key     ${jsonItemId}     ItemList
         ${Item_ID_Path}=    Get From Dictionary     ${jsonItemId}    ItemList
         Log To Console    ${jsonItemId}[ItemList][Item][_ItemID]
         RETURN     ${jsonItemId}[ItemList][Item][_ItemID]

Manage Item Multiline
    [Arguments]         ${CUR_DIR}
    ${manageItemJson}=     Manage Item With Dynamic Item ML       ${CUR_DIR}
    ${manageItemResponse}=     Post On Session     AddData   ${base_url_api}${manageItem}     data=${manageItemJson}
    status should be       204     ${manageItemResponse}
    ${jsonItemId}=     Manage Item With Dynamic Item1    ${CUR_DIR}
    Dictionary Should Contain Key     ${jsonItemId}     ItemList
         ${Item_ID_Path}=    Get From Dictionary     ${jsonItemId}    ItemList
         RETURN     ${Item_ID_Path}

Get Item ID
    [Arguments]    ${json_data}    ${CUR_DIR}
  # Convert JSON string to dictionary using Evaluate and json.loads, and directly access the item ID
    ${item_id}=    Evaluate    json.loads("""${json_data}""")['ItemList']['Item']['_ItemID']    modules=json
    # Log the extracted ItemID value
    Log To Console    ${item_id}
    RETURN    ${item_id}

Get Item ID ML
    [Arguments]    ${json_data}    ${CUR_DIR}
    Dictionary Should Contain Key     ${json_data}     Item
    ${Item}=    Get From Dictionary     ${json_data}    Item
    ${item_id1}=  Get From Dictionary  ${Item[0]}  _ItemID
    ${item_id}=  Get From Dictionary  ${Item[1]}  _ItemID
    Log To Console    ${Item_id}
    RETURN     ${Item_id}

Adjust Inventory
    [Arguments]    ${itemId}     ${CUR_DIR}
    ${adjInventoryJson} =    Adjust Inventory File    ${itemId}    ${CUR_DIR}
    ${response} =    Post On Session    AddData    ${base_url_api}${adjustInventory}    data=${adjInventoryJson}    headers=${headers}
    Status Should Be    204    ${response}

Adjust Inventory Multiline
    [Arguments]   ${CUR_DIR}
    ${adjInventoryJson} =    Adjust Inventory File ML   ${CUR_DIR}
    ${response} =    Post On Session    AddData    ${base_url_api}${adjustInventory}    data=${adjInventoryJson}    headers=${headers}
    Status Should Be    204    ${response}

Schedule Order
    [Arguments]     ${AddData}     ${Order_No}     ${Order_Header_Key}     ${CUR_DIR}
    ${Order_No1}=    Schedule Input File1     ${Order_No}     ${Order_Header_Key}     ${CUR_DIR}
    ${response1}=     Post On Session     ${AddData}   ${base_url_api}${scheduleOrder}     data=${Order_No1}    headers=${headers}

Release Order
    [Arguments]     ${AddData}     ${Order_No}     ${Order_Header_Key}     ${CUR_DIR}
    ${Order_No1}=    Release Input File1     ${Order_No}     ${Order_Header_Key}     ${CUR_DIR}
    ${response1}=     Post On Session     ${AddData}   ${base_url_api}${releaseOrder}     data=${Order_No1}    headers=${headers}

BackOrder
    [Arguments]     ${AddData}     ${Order_No}     ${values}     ${CUR_DIR}    ${flow_name}
    ${ip_data}=    Backorder Input File1     ${Order_No}     ${values}     ${CUR_DIR}
    ${response1}=     Post On Session     ${AddData}   ${base_url_flow}${flow_name}     data=${ip_data}    headers=${headers}
    ${respSoms}=    convert to string   ${response1.json()}
    Write Output File       ${respSoms}        ${SOMSNS}        ${CUR_DIR}


SOMSNS Order
    [Arguments]     ${AddData}     ${Order_No}     ${values}     ${CUR_DIR}
    ${Order_No1}=    SOMSNS Input File1     ${Order_No}     ${values}     ${CUR_DIR}
    ${response1}=     Post On Session     ${AddData}   ${base_url_flow}${SOMSNS}     data=${Order_No1}    headers=${headers}
    ${respSoms}=    convert to string   ${response1.json()}
    Write Output File       ${respSoms}        ${SOMSNS}        ${CUR_DIR}
    RETURN    ${respSoms}

Get Order Details
    [Arguments]     ${AddData}     ${Order_No}     ${Order_Header_Key}  ${CUR_DIR}
    ${Order_No2}=    GetOrderDetails Input File1     ${Order_No}     ${Order_Header_Key}     ${CUR_DIR}
    ${response1}=     Post On Session     AddData   ${base_url_api}${getOrderDetails}     data=${Order_No2}    headers=${headers}
     ${resp1}=    convert to string   ${response1.json()}
     Write Output File       ${resp1}        ${getOrderDetails}        ${CUR_DIR}
    Log To Console        'b7 getOrderDetails'
    Dictionary Should Contain Key     ${response1.json()}     Status
         ${Order_Status}=    Get From Dictionary     ${response1.json()}    Status
         Log To Console    ${Order_Status}
         ${values}=     Get Value From Json    ${response1.json()}    $..ItemID
         RETURN    ${values}

Find Inventory
    [Arguments]    ${itemId}     ${CUR_DIR}    ${scenario}
    ${findInventoryJson} =    Generic Input File  ${itemId}   ${CUR_DIR}    ${scenario}
    ${findInventoryResponse} =    Post On Session    AddData    ${base_url_flow}${EPLFindInventorySyncService}    data=${findInventoryJson}    headers=${headers}
    ${resp}=    convert to string   ${findInventoryResponse.json()}
    Write Output File       ${resp}        'findInv'    ${CUR_DIR}
    Dictionary Should Contain Key     ${findInventoryResponse.json()}     SuggestedOption
         ${Order_No}=    Get From Dictionary     ${findInventoryResponse.json()}    SuggestedOption
         ${Option}  Get From Dictionary  ${Order_No}  Option
          ${PromiseLines}  Get From Dictionary  ${Option}  PromiseLines
         ${PromiseLine}  Get From Dictionary  ${PromiseLines}  PromiseLine
          ${AssignmentsList}  Get From List  ${PromiseLine}  0
          ${assignments}  Get From Dictionary  ${AssignmentsList}  Assignments
          ${assignment}  Get From Dictionary  ${Assignments}  Assignment
         ${assignmentList}  Get From List  ${assignment}  0
         ${ShipNode}  Get From Dictionary  ${assignmentList}  ShipNode
         Set Test Message    ShipNode 127 suggested in Assignment ShipNode from response is ${ShipNode}

Find Inventory Multiline
    [Arguments]    ${CUR_DIR}    ${scenario}
    ${findInventoryJson} =    Find Inventory File Ml    ${CUR_DIR}
    ${findInventoryResponse} =    Post On Session    AddData    ${base_url_flow}${EPLFindInventorySyncService}    data=${findInventoryJson}    headers=${headers}
    ${resp}=    convert to string   ${findInventoryResponse.json()}
    Write Output File       ${resp}        'findInv'    ${CUR_DIR}
    Dictionary Should Contain Key     ${findInventoryResponse.json()}     SuggestedOption
         ${Order_No}=    Get From Dictionary     ${findInventoryResponse.json()}    SuggestedOption
         ${Option}  Get From Dictionary  ${Order_No}  Option
          ${PromiseLines}  Get From Dictionary  ${Option}  PromiseLines
         ${PromiseLine}  Get From Dictionary  ${PromiseLines}  PromiseLine
          ${AssignmentsList}  Get From List  ${PromiseLine}  0
          ${assignments}  Get From Dictionary  ${AssignmentsList}  Assignments
          ${assignment}  Get From Dictionary  ${Assignments}  Assignment
         ${assignmentList}  Get From List  ${assignment}  0
         ${ShipNode}  Get From Dictionary  ${assignmentList}  ShipNode
         Set Test Message    ShipNode 127 suggested in Assignment ShipNode from response is ${ShipNode}

Create Order
    [Arguments]    ${itemId}     ${CUR_DIR}
     ${jsonCreateOrder}=     Create Order File      ${itemId}    ${CUR_DIR}
    ${createOrderResponse}=     Post On Session     AddData   ${base_url_api}${createOrder}     data=${jsonCreateOrder}    headers=${headers}
    ${resp2}=    convert to string   ${createOrderResponse.json()}
    Write Output File       ${resp2}        'createOrder'        ${CUR_DIR}
    Log To Console    ${createOrderResponse}
    ${timestamp} =    Get Current Date    result_format=%Y%m%d-%H%M
         Dictionary Should Contain Key     ${createOrderResponse.json()}     OrderNo
         ${Order_No}=    Get From Dictionary     ${createOrderResponse.json()}    OrderNo
         Dictionary Should Contain Key     ${createOrderResponse.json()}     OrderHeaderKey
         ${Order_Header_Key}=    Get From Dictionary     ${createOrderResponse.json()}    OrderHeaderKey
         Append Excel File1  ${file}    ${Order_No}     ${TEST NAME}    ${timestamp}    ${jsonCreateOrder}     ${createOrderResponse.json()}
         RETURN    ${Order_No}    ${Order_Header_Key}

Create Order Multiline
    [Arguments]   ${CUR_DIR}
     ${jsonCreateOrder}=     Create Order File ML   ${CUR_DIR}
    ${createOrderResponse}=     Post On Session     AddData   ${base_url_api}${createOrder}     data=${jsonCreateOrder}    headers=${headers}
    ${resp2}=    convert to string   ${createOrderResponse.json()}
    Write Output File       ${resp2}        'createOrder'        ${CUR_DIR}
    Log To Console    ${createOrderResponse}
    ${timestamp} =    Get Current Date    result_format=%Y%m%d-%H%M
         Dictionary Should Contain Key     ${createOrderResponse.json()}     OrderNo
         ${Order_No}=    Get From Dictionary     ${createOrderResponse.json()}    OrderNo
         Dictionary Should Contain Key     ${createOrderResponse.json()}     OrderHeaderKey
         ${Order_Header_Key}=    Get From Dictionary     ${createOrderResponse.json()}    OrderHeaderKey
         Append Excel File1  ${file}    ${Order_No}     ${TEST NAME}    ${timestamp}    ${jsonCreateOrder}     ${createOrderResponse.json()}
         RETURN    ${Order_No}    ${Order_Header_Key}

Check Inventory Activity
    [Arguments]    ${itemId}     ${CUR_DIR}
    ${sql_stmt}=    Set Variable    select inventory_activity_key from omdb.yfs_inventory_activity where inventory_item_key in (select inventory_item_key from omdb.yfs_inventory_item where item_id = '${itemId}') and node_key = '113' order by modifyts desc;
    ${result} =    Execute Sql Stmt    ${sql_stmt}    ${CUR_DIR}
    Should Not Be Empty    ${result}

Add Node From DG
    [Arguments]         ${CUR_DIR}    ${scenario}
    ${JsonData} =    Generic Input File1     ${CUR_DIR}    ${scenario}
    ${response} =    Post On Session    AddData    ${base_url_flow}${EPLManageDistRuleSyncService}    data=${JsonData}    headers=${headers}
    RETURN     ${response}

Extract Error Description
    [Arguments]    ${response}
    Log To Console    '*************** extract'
    ${response_json}=    Convert To Dictionary    ${response.text}
    Log To Console    ${response_json}
    ${error_description}=    Get From Dictionary    ${response_json['errors'][0]}    ErrorDescription
    Log To Console        Error Description: ${error_description}

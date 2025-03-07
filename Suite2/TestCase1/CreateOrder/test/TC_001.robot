*** Settings ***
Resource    ../setUp/setUpForCreateOrder.robot
Test Setup
Library  xmltodict

*** Variables ***
${CUR_DIR}     ${CURDIR}
${manageItem_Input_file_Name}    manageItem
${adjustInventory_Input_file_Name}    adjustInventory
${createOrder_Input_file_Name}    createOrder
${getOrderDetails_Input_file_Name}    getOrderDetails

*** Test Cases ***
Create Order TC_001
    [Tags]      HAPPYFLOW    REGRESSION    CREATEORDER
    Manage MultiApi   ${CUR_DIR}    ${manageItem_Input_file_Name}
    Manage MultiApi   ${CUR_DIR}    ${adjustInventory_Input_file_Name}
    ${response}=     Manage MultiApi   ${CUR_DIR}    ${createOrder_Input_file_Name}
    # First, access the 'API' dictionary
    ${api}=  Get From Dictionary  ${response.json()}  API
    # Then, access the 'Output' dictionary within 'API'
    ${output}=  Get From Dictionary  ${api}  Output
    # Now access the 'Order' dictionary within 'Output'
    ${order}=  Get From Dictionary  ${output}  Order
    # Finally, access 'OrderHeaderKey' from the 'Order' dictionary
    ${Order_No}=  Get From Dictionary  ${order}  OrderNo
    ${order_header_key}=  Get From Dictionary  ${order}  OrderHeaderKey
    Log  ${order_header_key}
    ${orderOutput}=     Fetch Order Output    ${response}
    Log To Console    ${orderOutput}
    ${Order_No2}=    GetOrderDetails Input File     ${Order_No}     ${Order_Header_Key}     ${CUR_DIR}
    Log To Console    ${Order_No2}

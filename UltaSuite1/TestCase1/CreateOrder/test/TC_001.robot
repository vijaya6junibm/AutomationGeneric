*** Settings ***
Resource    ../setUp/setUpForCreateOrder.robot
Test Setup
Library  xmltodict
Library         Collections
Library         RequestsLibrary
Library         XML

*** Variables ***
${CUR_DIR}     ${CURDIR}

*** Test Cases ***
Create Order TC_001
    [Tags]      HAPPYFLOW    REGRESSION    CREATEORDER    ULTA    skip
    ${createOrderReq}=     Generic Input File   ${CUR_DIR}    ${createOrder_Input_file_Name}
    ${createOrderResp}=     Creating Session Sample1    ${createOrder_Input_file_Name}   ${createOrderReq}
    ${order}=     Get Element    ${createOrderResp.content}    .//Order
    ${OrderNo}=    Get Element Attribute    ${order}    OrderNo
    Log To Console    ${OrderNo}
    Get Order Details    ${CUR_DIR}   Created    ${OrderNo}

Schedule Order TC_001
    [Tags]      HAPPYFLOW    REGRESSION    SCHEDULEORDER    ULTA    skip
    ${createOrderReq}=     Generic Input File   ${CUR_DIR}    ${createOrder_Input_file_Name}
    ${createOrderResp}=     Creating Session Sample1    ${createOrder_Input_file_Name}   ${createOrderReq}
    ${order}=     Get Element    ${createOrderResp.content}    .//Order
    ${OrderNo}=    Get Element Attribute    ${order}    OrderNo
    Log To Console    ${OrderNo}
    ${resp2}=   Manage MultiApi Ulta     ${CUR_DIR}    ${scheduleOrder_Input_file_Name}
    Get Order Details    ${CUR_DIR}   Scheduled    ${OrderNo}
    Log To Console    ${resp2.json()}

Release Order TC_001
    [Tags]      HAPPYFLOW    REGRESSION    RELEASEORDER    ULTA    skip
    ${createOrderReq}=     Generic Input File   ${CUR_DIR}    ${createOrder_Input_file_Name}
    ${createOrderResp}=     Creating Session Sample1    ${createOrder_Input_file_Name}   ${createOrderReq}
    ${order}=     Get Element    ${createOrderResp.content}    .//Order
    ${OrderNo}=    Get Element Attribute    ${order}    OrderNo
    Manage MultiApi Ulta     ${CUR_DIR}    ${scheduleOrder_Input_file_Name}
    Manage MultiApi Ulta     ${CUR_DIR}    ${releaseOrder_Input_file_Name}
    Get Order Details    ${CUR_DIR}   Released    ${OrderNo}

Confirm Shipment TC_001
    [Tags]      HAPPYFLOW    REGRESSION    RELEASEORDER    ULTA    skip
    ${createOrderReq}=     Generic Input File   ${CUR_DIR}    ${createOrder_Input_file_Name}
    ${createOrderResp}=     Creating Session Sample1    ${createOrder_Input_file_Name}   ${createOrderReq}
    ${order}=     Get Element    ${createOrderResp.content}    .//Order
    ${OrderNo}=    Get Element Attribute    ${order}    OrderNo
    ${OrderHeaderKey}=    Get Element Attribute    ${order}    OrderHeaderKey
    Manage MultiApi Ulta     ${CUR_DIR}    ${scheduleOrder_Input_file_Name}
    Manage MultiApi Ulta     ${CUR_DIR}    ${releaseOrder_Input_file_Name}
    ${confirmShipmentXmlRequest}=    Confirm Shipment    ${OrderNo}    ${OrderHeaderKey}
    ${confirmShipmentResp}=     Creating Session Sample1    ${confirmShipment_Input_file_Name}   ${confirmShipmentXmlRequest}
    Get Order Details    ${CUR_DIR}   Shipped    ${OrderNo}
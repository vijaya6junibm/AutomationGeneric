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
    ${createOrderResp}=    Create Order    ${CUR_DIR}
    ${OrderNo}=    Fetch Order No    ${createOrderResp}
    Get Order Details    ${CUR_DIR}   Created    ${OrderNo}

Schedule Order TC_001
    [Tags]      HAPPYFLOW    REGRESSION    SCHEDULEORDER    ULTA    skip
    ${createOrderResp}=    Create Order    ${CUR_DIR}
    ${OrderNo}=    Fetch Order No    ${createOrderResp}
    ${resp2}=   Manage MultiApi Ulta     ${CUR_DIR}    ${scheduleOrder_Input_file_Name}
    Get Order Details    ${CUR_DIR}   Scheduled    ${OrderNo}

Release Order TC_001
    [Tags]      HAPPYFLOW    REGRESSION    RELEASEORDER    ULTA    skip
    ${createOrderResp}=    Create Order    ${CUR_DIR}
    ${OrderNo}=    Fetch Order No    ${createOrderResp}
    Manage MultiApi Ulta     ${CUR_DIR}    ${scheduleOrder_Input_file_Name}
    Get Order Details    ${CUR_DIR}   Scheduled    ${OrderNo}
    Manage MultiApi Ulta     ${CUR_DIR}    ${releaseOrder_Input_file_Name}
    Get Order Details    ${CUR_DIR}   Released    ${OrderNo}

Confirm Shipment TC_001
    [Tags]      HAPPYFLOW    REGRESSION    RELEASEORDER    ULTA    skip
    ${createOrderResp}=    Create Order    ${CUR_DIR}
    ${OrderNo}=    Fetch Order No    ${createOrderResp}
    ${OrderHeaderKey}=    Fetch OrderHeaderKey    ${createOrderResp}
    Manage MultiApi Ulta     ${CUR_DIR}    ${scheduleOrder_Input_file_Name}
    Get Order Details    ${CUR_DIR}   Scheduled    ${OrderNo}
    Manage MultiApi Ulta     ${CUR_DIR}    ${releaseOrder_Input_file_Name}
    Get Order Details    ${CUR_DIR}   Released    ${OrderNo}
    ${confirmShipmentXmlRequest}=    Confirm Shipment    ${OrderNo}    ${OrderHeaderKey}
    ${confirmShipmentResp}=     Creating Session Sample1    ${confirmShipment_Input_file_Name}   ${confirmShipmentXmlRequest}
    Get Order Details    ${CUR_DIR}   Shipped    ${OrderNo}
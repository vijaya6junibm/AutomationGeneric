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
    #${createOrderResp}=   Manage MultiApi Ulta     ${CUR_DIR}    ${createOrder_Input_file_Name}
    ${createOrderReq}=     Generic Input File   ${CUR_DIR}    ${createOrder_Input_file_Name}
    ${createOrderResp}=     Creating Session Sample1    ${createOrder_Input_file_Name}   ${createOrderReq}
    ${order}=     Get Element    ${createOrderResp.content}    .//Order
    ${OrderNo}=    Get Element Attribute    ${order}    OrderNo
    ${OrderHeaderKey}=    Get Element Attribute    ${order}    OrderHeaderKey
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
    ${getOrderReleaseListxmlRequest}=     Generic Input File Oh     ${CUR_DIR}    ${getOrderReleaseList_Input_file_Name}    ${OrderHeaderKey}
    ${resp}=     Creating Session Sample1    ${getOrderReleaseList_Input_file_Name}   ${getOrderReleaseListxmlRequest}
    ${getOrderDetailResp}=    Get Order Details    ${CUR_DIR}   Released    ${OrderNo}
    ${order}=     Get Element    ${getOrderDetailResp.content}    .//Order
    ${Status}=    Get Element Attribute    ${order}    Status
    ${OrderLine}=     Get Element    ${getOrderDetailResp.content}    .//OrderLine
    ${OrderLineKey}=    Get Element Attribute    ${OrderLine}    OrderLineKey
    ${OrderedQty}=    Get Element Attribute    ${OrderLine}    OrderedQty
    Parse XML    ${resp.content}
    ${orderAttr}=     Get Element    ${resp.content}    .//OrderReleaseList/OrderRelease
    ${orderReleaseKey}=    Get Element Attribute    ${orderAttr}    OrderReleaseKey
    ${CarrierServiceCode}=    Get Element Attribute    ${orderAttr}    CarrierServiceCode
    ${DocumentType}=    Get Element Attribute    ${orderAttr}    DocumentType
    ${EnterpriseCode}=    Get Element Attribute    ${orderAttr}    EnterpriseCode
    ${SCAC}=    Get Element Attribute    ${orderAttr}    SCAC
    ${ShipNode}=    Get Element Attribute    ${orderAttr}    ShipNode

    ${confirmShipmentXmlRequest}=     Generic Input File Ship     ${CUR_DIR}    ${confirmShipment_Input_file_Name}    ${orderReleaseKey}     ${CarrierServiceCode}    ${EnterpriseCode}    ${SCAC}    ${ShipNode}    ${OrderLineKey}    ${OrderedQty}    ${DocumentType}    ${OrderNo}
    ${confirmShipmentResp}=     Creating Session Sample1    ${confirmShipment_Input_file_Name}   ${confirmShipmentXmlRequest}
    Get Order Details    ${CUR_DIR}   Shipped    ${OrderNo}
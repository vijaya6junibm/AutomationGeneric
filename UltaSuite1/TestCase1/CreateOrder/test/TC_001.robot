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
    ${getOrderReleaseListxmlRequest}=     Generic Input File Oh     ${CUR_DIR}    ${getOrderReleaseList_Input_file_Name}    ${OrderHeaderKey}
    ${resp}=     Creating Session Sample1    ${getOrderReleaseList_Input_file_Name}   ${getOrderReleaseListxmlRequest}
    Log To Console    ${resp.content}
    Get Order Details    ${CUR_DIR}   Released    ${OrderNo}
    ${orderNo2}=    Get Element Attribute    ${resp.content}    //OrderRelease/@OrderReleaseKey
    ${orderNo}=    Get Element Attribute    ${resp.content}    .//OrderReleaseList/OrderRelease[@OrderReleaseKey]
    Parse XML    ${resp.content}
    ${orderAttr}=     Get Element    ${resp.content}    .//OrderReleaseList/OrderRelease
    ${orderReleaseKey}=    Get Element Attribute    ${orderAttr}    OrderReleaseKey
*** Settings ***
Resource    ../setUp/setUpForCreateOrder.robot
Test Setup
Library  xmltodict
Library         Collections
Library         RequestsLibrary
Library         XML

*** Variables ***
${CUR_DIR}     ${CURDIR}
${createOrder_Input_file_Name}    createOrder
${scheduleOrder_Input_file_Name}    scheduleOrder
${releaseOrder_Input_file_Name}    releaseOrder
${getOrderReleaseList_Input_file_Name}    getOrderReleaseList
${getOrderDetails_Input_file_Name}    getOrderDetails
${base_url}    http://9.30.252.13:9080
${req_uri}      /smcfs/interop/InteropHttpServlet


*** Test Cases ***
Create Order
        ${xmlRequest}=     Generic Input File   ${CUR_DIR}    ${getOrderReleaseList_Input_file_Name}
        ${resp}=     Creating Session Sample1    ${getOrderReleaseList_Input_file_Name}   ${xmlRequest}
        ${orderNo2}=    Get Element Attribute    ${resp.content}    //OrderRelease/@OrderReleaseKey
        ${orderNo}=    Get Element Attribute    ${resp.content}    .//OrderReleaseList/OrderRelease[@OrderReleaseKey]
        Parse XML    ${resp.content}
        ${orderAttr}=     Get Element    ${resp.content}    .//OrderReleaseList/OrderRelease
        ${orderReleaseKey}=    Get Element Attribute    ${orderAttr}    OrderReleaseKey
        Log To Console    'orderReleaseKey'
        Log To Console    ${orderReleaseKey}
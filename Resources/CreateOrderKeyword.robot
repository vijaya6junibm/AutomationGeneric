*** Settings ***
Library       Collections
Library       RequestsLibrary
Library     ../Resources/Create_Order_Xml_Content.py
Library      JSONLibrary
Library      ../Resources/read_write_all_excel.py
Library      ../Resources/Prepare_Xml_Content.py
Library           DateTime
Library              OperatingSystem
Library    String
Resource     createSession.robot


*** Variables ***
${base_url_api}         http://9.30.26.220:9080/smcfs/restapi/invoke/
${base_url_api1}         http://9.30.252.13:9080/smcfs/restapi/invoke/
${base_url_flow}         http://9.30.26.220:9080/smcfs/restapi/executeFlow/
${user}             admin
${passwd}           password
&{headers}          Content-Type=application/xml  Authorization=Basic YWRtaW46cGFzc3dvcmQ=
${auth}=  Create List  ${user}  ${passwd}
${file}           TestResults.csv
${file1}           TestResults1.csv
${createOrder}             createOrder
${manageItem}             manageItem
${adjustInventory}             adjustInventory
${multiApi}             multiApi
${base_url}    http://9.30.252.13:9080
${req_uri}      /smcfs/interop/InteropHttpServlet




*** Keywords ***
Create Order SL
    [Arguments]         ${jsonItemId}    ${CUR_DIR}
    ${jsonCreateOrder}=     Create Order File      ${jsonItemId}[ItemList][Item][_ItemID]    ${CUR_DIR}
    ${createOrderResponse}=     Post On Session     AddData   ${base_url_api}${createOrder}     data=${jsonCreateOrder}    headers=${headers}
    ${resp2}=    convert to string   ${createOrderResponse.json()}
    Write Output File       ${resp2}        'createOrder'        ${CUR_DIR}
    ${timestamp} =    Get Current Date    result_format=%Y%m%d-%H%M
         Dictionary Should Contain Key     ${createOrderResponse.json()}     OrderNo
         ${Order_No}=    Get From Dictionary     ${createOrderResponse.json()}    OrderNo
         Dictionary Should Contain Key     ${createOrderResponse.json()}     OrderHeaderKey
         ${Order_Header_Key}=    Get From Dictionary     ${createOrderResponse.json()}    OrderHeaderKey
         Append Excel File1  ${file}    ${Order_No}     ${TEST NAME}    ${timestamp}    ${jsonCreateOrder}     ${createOrderResponse.json()}
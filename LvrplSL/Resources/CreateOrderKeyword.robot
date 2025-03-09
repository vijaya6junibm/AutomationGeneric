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
${base_url_flow}         http://9.30.26.220:9080/smcfs/restapi/executeFlow/
${user}             admin
${passwd}           password
&{headers}          Content-Type=application/xml  Authorization=Basic YWRtaW46cGFzc3dvcmQ=
${headers_xml}=      Create Dictionary Authorization=Basic YWRtaW46cGFzc3dvcmQ= accept=application/xml Content-Type=application/xml
${auth}=  Create List  ${user}  ${passwd}
${error_description}        Item(Item Id and UOM) does not exist
${file}           TestResults.csv
${file1}           TestResults1.csv
${createOrder}             createOrder
${scheduleOrder}             scheduleOrder
${releaseOrder}             releaseOrder
${manageItem}             manageItem
${multiApi}             multiApi
${adjustInventory}             adjustInventory
${findInventory}             findInventory
${getOrderDetails}             getOrderDetails
${EPLSafetyFactorLoadSyncService}             EPLSafetyFactorLoadSyncService
${getItemNodeDefnList}             getItemNodeDefnList
${SOMSNS}             SOMSNS
${EPLFindInventorySyncService}             EPLFindInventorySyncService
${getOrderDetails}             getOrderDetails
${TC001_Path}             TC_001_CreateOrderPos - create normal order
${TC002_Path}             TC_002_CreateOrderPos - create normal order ClickandCollect
${TC003_Path}             TC_003_CreateOrderApp - create normal order
${TC004_Path}             TC_004_CreateOrderApp - create normal order ClickandCollect
${TC001_Manage_Item_Path}             ItemDynamic
${dirpath}        C:/EPL-Liverpool-SL/CreateOrder
${dirpath1}        C:/EPL-Liverpool-SL/EPLOpenOrdersMigration
#flash stores
${ePLCreateFlashStoreSyncService}             EPLCreateFlashStoreSyncService
${ePLUpdateExtnFlashStoreSyncService}             EPLChangeFlashStoreSyncService
${ePLGetFlashStoreListSyncService}             EPLGetFlashStoreListSyncService
${ePLDeleteFlashStoreSyncService}                EPLDeleteFlashStoreSyncService
${EPLFlashStoreLoadSyncService}                EPLFlashStoreLoadSyncService
${EPLManageDistRuleSyncService}                EPLManageDistRuleSyncService
${EPLPusblishToBackorderEWMQ}                EPLPusblishToBackorderEWMQ
${EPLPublishToBackorderAppSurtidoQ}                EPLPublishToBackorderAppSurtidoQ
${AUTHORIZATION}    Basic YWRtaW46cGFzc3dvcmQ=
# Defining headers as a dictionary
#&{headers}    {'Content-Type': 'application/xml', 'Authorization': '${AUTHORIZATION}'}


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
    
Create Order SL1
    [Arguments]         ${jsonItemId}    ${CUR_DIR}
    Creating Session XML    api
    ${headers_dict_xml}=       Create Dictionary    Authorization=${AUTHORIZATION}    Content-Type=application/xml
    ${jsonCreateOrder}=     Create Order File      ${jsonItemId}[ItemList][Item][_ItemID]    ${CUR_DIR}
    ${createOrderResponse}=     Post On Session     api   ${base_url_api}${createOrder}     data=${jsonCreateOrder}    headers=${headers_dict_xml}
    Log To Console   ${createOrderResponse}
    # Get the Content-Type from the response headers
    ${content_type}=  Get From Dictionary    ${createOrderResponse.headers}    Content-Type
    Log To Console    ${content_type}
    Log To Console    '**************content type'
    # Log the Content-Type header
    Log To Console    Content-Type: ${content_type}
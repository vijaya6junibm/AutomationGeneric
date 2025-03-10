*** Settings ***
Resource     ../../../../Resources/CreateOrderKeyword.robot
Resource    ../../../../Resources/createSession.robot
Library           DateTime
Library              OperatingSystem
Library      RequestsLibrary
Library      xmltodict
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
${confirmShipment_Input_file_Name}    confirmShipment

*** Keywords ***

Create Item Adjust and Fin Inv SL
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
    RETURN    ${jsonItemId}

Manage MultiApi
    [Arguments]         ${CUR_DIR}    ${input_file_Name1}
    Creating Session Generic    ${input_file_Name1}    ${input_file_Name1}
    ${Json}=     Generic Input File   ${CUR_DIR}    ${input_file_Name1}
    ${response}=     Post On Session     ${input_file_Name1}   ${base_url_api}${multiApi}     data=${Json}
    #RETURN    ${response}
    status should be       200     ${response}
    ${response1}=    Convert Json To Xml    ${response.json()}
    RETURN    ${response}

Manage MultiApi Ulta
    [Arguments]         ${CUR_DIR}    ${input_file_Name1}
    Creating Session ULTA    ${input_file_Name1}    ${input_file_Name1}
    ${Json}=     Generic Input File   ${CUR_DIR}    ${input_file_Name1}
    ${response}=     Post On Session     ${input_file_Name1}   ${base_url_api1}${multiApi}     data=${Json}
    #RETURN    ${response}
    status should be       200     ${response}
    ${response1}=    Convert Json To Xml    ${response.json()}
    RETURN    ${response}

Confirm Shipment
    [Arguments]         ${OrderNo}    ${OrderHeaderKey}
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
    RETURN     ${confirmShipmentXmlRequest}

Get Order Details
    [Arguments]         ${CUR_DIR}    ${status_name}    ${OrderNo}
    ${getOrderDetailsxmlRequest}=     Generic Input File Ord    ${CUR_DIR}    ${getOrderDetails_Input_file_Name}    ${OrderNo}
    ${getOrderDetailResp}=     Creating Session Sample1    ${getOrderDetailsxmlRequest}   ${getOrderDetailsxmlRequest}
    ${order}=     Get Element    ${getOrderDetailResp.content}    .//Order
    ${Status}=    Get Element Attribute    ${order}    Status
    Should Be Equal As Strings    ${Status}    ${status_name}
    RETURN     ${getOrderDetailResp}
    

Fetch Order Output
    [Arguments]    ${response}
     # First, access the 'API' dictionary
    ${api}=  Get From Dictionary  ${response.json()}  API
    # Then, access the 'Output' dictionary within 'API'
    ${output}=  Get From Dictionary  ${api}  Output
    # Now access the 'Order' dictionary within 'Output'
    ${order}=  Get From Dictionary  ${output}  Order

Create Order
    [Arguments]         ${CUR_DIR}
    ${createOrderReq}=     Generic Input File   ${CUR_DIR}    ${createOrder_Input_file_Name}
    ${createOrderResp}=     Creating Session Sample1    ${createOrder_Input_file_Name}   ${createOrderReq}
    RETURN     ${createOrderResp}

Fetch Order No
    [Arguments]         ${createOrderResp}
    ${order}=     Get Element    ${createOrderResp.content}    .//Order
    ${OrderNo}=    Get Element Attribute    ${order}    OrderNo
    RETURN     ${OrderNo}

Fetch OrderHeaderKey
    [Arguments]         ${createOrderResp}
    ${order}=     Get Element    ${createOrderResp.content}    .//Order
    ${OrderHeaderKey}=    Get Element Attribute    ${order}    OrderHeaderKey
    RETURN     ${OrderHeaderKey}


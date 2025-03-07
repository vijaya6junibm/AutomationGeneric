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
    

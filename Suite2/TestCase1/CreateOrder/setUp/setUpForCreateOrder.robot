*** Settings ***
Resource     ../../../../Resources/CreateOrderKeyword.robot
Resource    ../../../../Resources/createSession.robot
Library           DateTime
Library              OperatingSystem
Library      RequestsLibrary
Library      xmltodict

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
    

Fetch Order Output
    [Arguments]    ${response}
     # First, access the 'API' dictionary
    ${api}=  Get From Dictionary  ${response.json()}  API
    # Then, access the 'Output' dictionary within 'API'
    ${output}=  Get From Dictionary  ${api}  Output
    # Now access the 'Order' dictionary within 'Output'
    ${order}=  Get From Dictionary  ${output}  Order
    

*** Settings ***
Resource     ../../Resources/CreateOrderKeyword.robot
Library     ../../Resources/read_write_all_excel.py
Resource    ../../Resources/createSession.robot
Library     ../../Resources/Prepare_Xml_Content.py
Library           DateTime
Library              OperatingSystem

*** Keywords ***

Create Item Adjust and Fin Inv SL
    Creating Session1     AddData
    ${manageItemJson}=     Manage Item With Dynamic Item        ${CUR_DIR}
    ${manageItemResponse}=     Post On Session     AddData   ${base_url_api}${manageItem}     data=${manageItemJson}
    status should be       204     ${manageItemResponse}
    ${jsonItemId}=     Manage Item With Dynamic Item1    ${CUR_DIR}
    Dictionary Should Contain Key     ${jsonItemId}     ItemList
         ${Item_ID_Path}=    Get From Dictionary     ${jsonItemId}    ItemList
         ${jsonAdjInv}=     Adjust Inventory File          ${jsonItemId}[ItemList][Item][_ItemID]    ${CUR_DIR}
    ${adjInvresponse}=     Post On Session     AddData   ${base_url_api}${adjustInventory}     data=${jsonAdjInv}    headers=${headers}
    status should be       204     ${adjInvresponse}
         ${jsonfindInventory}=     Find Inventory File       ${jsonItemId}[ItemList][Item][_ItemID]    ${CUR_DIR}
    ${findInventoryResponse}=     Post On Session     AddData   ${base_url_api}${findInventory}     data=${jsonfindInventory}    headers=${headers}
    ${resp}=    convert to string   ${findInventoryResponse.json()}
    Write Output File       ${resp}        'findInv'    ${CUR_DIR}
    RETURN    ${jsonItemId}
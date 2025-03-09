*** Settings ***
Resource     ../../../Resources/CreateOrderKeyword.robot
Resource    ../setUp/setUpForCreateOrder.robot
Test Setup     Create Item Adjust and Fin Inv SL

*** Variables ***
${CUR_DIR}     ${CURDIR}

*** Test Cases ***
Create Order TC_001
    [Tags]      HAPPYFLOW    REGRESSION    CREATEORDER
    ${jsonItemId}=    Create Item Adjust and Fin Inv SL
    Create Order SL1    ${jsonItemId}    ${CUR_DIR}

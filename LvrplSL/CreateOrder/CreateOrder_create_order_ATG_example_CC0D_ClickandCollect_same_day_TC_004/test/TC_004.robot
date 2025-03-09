*** Settings ***
Resource     ../../../Resources/CreateOrderKeyword.robot
Resource    ../../../Resources/SuiteSetup/suiteSetUpForCreateOrder.robot

*** Variables ***
${CUR_DIR}     ${CURDIR}

*** Test Cases ***
Create Order TC_004
    [Tags]      HAPPYFLOW    REGRESSION    CREATEORDER
    ${jsonItemId}=    Create Item Adjust and Fin Inv SL
    Create Order SL    ${jsonItemId}    ${CUR_DIR}

*** Settings ***
Resource     CreateOrderKeyword.robot
Library           DateTime
Library              OperatingSystem
#Test Setup     Manage Item TC_001
#Test Teardown

*** Variables ***

*** Keywords ***
Creating Session1
    [Arguments]     ${AddData}
    ${auth}=  Create List  ${user}  ${passwd}
    Create Session  ${AddData}  url=${base_url_api}${createOrder}  headers=${headers}  auth=${auth}
    
Creating Session Generic
    [Arguments]     ${AddData}    ${name}
    ${auth}=  Create List  ${user}  ${passwd}
    Create Session  ${AddData}  url=${base_url_api}${name}  headers=${headers}  auth=${auth}

    

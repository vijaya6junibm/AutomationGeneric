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

Creating Session ULTA
    [Arguments]     ${AddData}    ${name}
    ${auth}=  Create List  ${user}  ${passwd}
    Create Session  ${AddData}  url=${base_url_api1}${name}  headers=${headers}  auth=${auth}
 
Creating Session Sample1
    [Arguments]     ${AddData}      ${xmlRequest}
    Create Session    ${AddData}    ${BASE_URL}
    ${params}   create dictionary   YFSEnvironment.progId=Test      InteropApiName=multiApi     ApiName=MultiApi        YFSEnvironment.userId=admin     YFSEnvironment.password=password       InteropApiData=${xmlRequest}       timeout=30
    ${resp}=       POST On Session    ${AddData}    ${req_uri}  params=${params}
    RETURN    ${resp}

    

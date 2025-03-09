*** Settings ***
Documentation     API Testing in Robot Framework
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem

*** Variables ***
${dev_b_token}    Bearer CuDeHLMXIo1u7i3kh22WIVh5w3iCIDDV
${dev_b_server}    https://api.watsoncommerce.ibm.com
${params}         kod=BI1K

*** Test Cases ***
Do a GET Request with Bearer token
    &{headers}    Create Dictionary    Authorization=${dev_b_token}
    Create Session    dev_b_session    ${dev_b_server}
    Log    ${headers}
    ${response}=    GET On session    dev_b_session    /inventory/us-bae29482/v1/configuration/shipNodes/0007    headers=${headers}
    Log    ${response}
    Log To Console    ${response.json()}
    Status Should Be    200    ${response}    #Check Status as 200
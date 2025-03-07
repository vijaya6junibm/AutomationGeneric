*** Settings ***
Library         Collections
Library         RequestsLibrary
Library         XML
#Library         OS


*** Variables ***
${base_url}    http://9.30.204.111:9080
${req_uri}      /smcfs/interop/InteropHttpServlet
${USERNAME}    admin
${PASSWORD}    password


*** Test Cases ***
Play around with Dictionary
        &{data}=   Create Dictionary        name=bala       course=robotframework
        log     ${data}
        Dictionary Should Contain Key       ${data}     name

# Create an authenticated session
        #Create Session    my_session    ${BASE_URL}    auth=${USERNAME}:${PASSWORD}

# Define the XML payload
    #${XML_BODY}=    Set Variable    <Request>   <User>TestUser</User>   <Password>TestPass</Password>   </Request>

Create Order
        ${xml}=    Parse xml       /Users/balakrishnanrajenderan/Documents/TestingAutomation/LiverPool/Scenarios/CreateAndProcessOrderManually/setup/setup001.xml
        ${orderNo}=     get element     ${xml}  ../MultiApi/API
        Log to console    ${orderNo}
        ${xmlRequest}=    Set Variable    <MultiApi><API Name="getOrganizationHierarchy"><Input><Organization OrganizationCode="WESCO"/></Input></API></MultiApi>
        #${auth}=    create list    admin    password
        Create Session    my_session    ${BASE_URL}
        ${params}   create dictionary   YFSEnvironment.progId=Test      InteropApiName=multiApi     ApiName=MultiApi        YFSEnvironment.userId=admin     YFSEnvironment.password=password       InteropApiData=${xmlRequest}       timeout=30
        #${response}=    POST On Session    ${base_url}     data=${xmlRequest}     expected_status=200      timeout=30      auth=${USERNAME}:${PASSWORD}
        #Create dictionary   Content-Type=application/xml
        #${kwargs} Create Arguments Dictionary data=${data} json=${json} params=${params} headers=${headers} files=${files} allow_redirects=${allow_redirects} timeout=${timeout}
        ${resp}=       POST On Session    my_session    ${req_uri}  params=${params}
        Log to console    ${resp.status_code}
        Log to console    ${resp.content}

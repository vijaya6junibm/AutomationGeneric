*** Settings ***
Resource    ../setUp/setUpForCreateOrder.robot
Test Setup
Library  xmltodict
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
${base_url}    http://9.30.252.13:9080
${req_uri}      /smcfs/interop/InteropHttpServlet


*** Test Cases ***
Create Order
        ${xmlRequest}=    Set Variable    <MultiApi><API Name="getOrderReleaseList"><Input><OrderRelease OrderHeaderKey="20250307074316347663"/></Input><Template><OrderReleaseList TotalOrderReleaseList=""><OrderRelease OrderReleaseKey="" DocumentType="" EnterpriseCode="" SCAC="" CarrierServiceCode="" ShipNode=""/></OrderReleaseList></Template></API></MultiApi>
        Create Session    my_session    ${BASE_URL}
        ${params}   create dictionary   YFSEnvironment.progId=Test      InteropApiName=multiApi     ApiName=MultiApi        YFSEnvironment.userId=admin     YFSEnvironment.password=password       InteropApiData=${xmlRequest}       timeout=30
        ${resp}=       POST On Session    my_session    ${req_uri}  params=${params}
        Log to console    ${resp.status_code}
        Log To Console    'response content'
        Log to console    ${resp.content}
        ${orderNo2}=    Get Element Attribute    ${resp.content}    //OrderRelease/@OrderReleaseKey
        Log To Console    'blk2'
        Log to console    ${orderNo2}
        Log To Console    'parsed xml'
        Log To Console    ${resp.content}
        ${orderNo}=    Get Element Attribute    ${resp.content}    .//OrderReleaseList/OrderRelease[@OrderReleaseKey]
        Log To Console    '***********************************************8'
        #${title}=  Get Element Attribute  ${xpath}    attribute=title
        Log to console    ${orderNo}
        Log To Console    'response content block------------------------'
        Log To Console    ${resp.content}
        #Write Output File       ${resp.content}        'createOrder'        ${CURDIR}
       # ${orderReleaseList}=    Get Element    ${resp.content}    //OrderReleaseList
       # Log To Console        ${orderReleaseList}
        Parse XML    ${resp.content}
        Log To Console    'parsed content'
        Log To Console    ${resp}
        Log To Console    'type------------------------------------------'
        Log To Console    Content-Type: ${resp}
        
        # Check the Content-Type to ensure it is XML
        #${content_type}=    Get From Dictionary    ${resp.headers}    Content-Type
        #Log To Console        Content-Type: ${content_type}
        #Run Keyword If    '${content_type}' == 'application/xml'    Log    Response is XML.
        #Run Keyword If    '${content_type}' != 'application/xml'    Fail    Response is not XML.
    
        # Parse the XML content from the response
        Parse XML    ${resp.content}
    
        # Use XPath to get the OrderReleaseList element
        ${orderReleaseList}=    Get Element    ${resp.content}    .//OrderReleaseList
        ${orderAttr}=     Get Element    ${resp.content}    .//OrderReleaseList/OrderRelease
        ${orderReleaseKey}=    Get Element Attribute    ${orderAttr}    OrderReleaseKey
        Log To Console    'orderReleaseKey'
        Log To Console    ${orderReleaseKey}
        ${data_attrs}=    Get Element Attributes    ${orderAttr}
        # Copy specified attributes or all attributes if none specifiedIF    ${attributes_to_copy} == ${None}
        # Copy all attributes that exist in data XML
        FOR    ${attr_name}    ${attr_value}    IN    &{data_attrs}
            Log To Console    'inside for loop'
            Log To Console    ${attr_name}    ${attr_value}
        END
        #Set Element Attribute    ${template_order}    ${attr_name}    ${attr_value}    END
        Log To Console    ${orderAttr}
        Log To Console    ${orderReleaseList}
import json
import time
from datetime import datetime
import string
from xml.dom import minidom

import xmltodict
import xml.etree.ElementTree as ET
import dicttoxml
import json

def manage_item_with_dynamic_item1(folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/manageItemInputWithItemId.xml'
    with open(tpath) as fd:
        doc = fd.read()
        print('after mod', doc)
        doc1 = xmltodict.parse(doc)
        json_content = json.loads(json.dumps(doc1).replace("@", "_"))
        return json_content

def manage_item_with_dynamic_item(folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/manageItemInput.xml'
    with open(tpath) as fd:
        doc = fd.read()
        dt = datetime.today().strftime('%Y%m%d%H%M%S')+ str(int(time.time() * 1000) % 1000)
        print('before mod', doc)
        doc = doc.replace('$ItemID', dt)
        tdirpath = folder_path1 + '/Input/manageItemInputWithItemId.xml'
        with open(tdirpath, 'w', newline='') as fd1:
            fd1.write(doc)
        print('after mod', doc)
        time.sleep(2)  # Sleep for 5 seconds
    return doc

def adjust_inventory_file(item_id,folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/adjInvInput.xml'
    tdirpath = folder_path1 + '/Input/adjInvInputWithItemId.xml'
    with open(tpath) as fd:
        doc = fd.read()
        doc = doc.replace('$ItemID', item_id)
    return doc

def create_order_file(item_id,folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/createOrderInput.xml'
    with open(tpath) as fd:
        doc = fd.read()
        doc = doc.replace('$ItemID', item_id)
        doc = doc.replace('$OrderNo', item_id)
    return doc

def write_output_file(output1,output,folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    with open(folder_path1 +'/Output/'+output+'.xml', 'w', newline='') as fd:
        fd.write(output1)

def dict_to_xml(dictionary):
    return dicttoxml.dicttoxml(dictionary).decode()

def generic_input_file(folder_path,file_name):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/'+file_name+'.xml'
    with open(tpath) as fd:
        doc = fd.read()
    return doc

def generic_input_file_oh(folder_path,file_name,oh):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/'+file_name+'.xml'
    with open(tpath) as fd:
        doc = fd.read()
        doc = doc.replace('${OrderHeaderKey}', oh)
    return doc

def generic_input_file_ship(folder_path,file_name,orderReleaseKey,CarrierServiceCode,EnterpriseCode,SCAC,ShipNode,OrderLineKey,OrderedQty,DocumentType,OrderNo):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/'+file_name+'.xml'
    with open(tpath) as fd:
        doc = fd.read()
        doc = doc.replace('${OrderReleaseKey}', orderReleaseKey)
        doc = doc.replace('${CarrierServiceCode}', CarrierServiceCode)
        doc = doc.replace('${EnterpriseCode}', EnterpriseCode)
        doc = doc.replace('${SCAC}', SCAC)
        doc = doc.replace('${ShipNode}', ShipNode)
        doc = doc.replace('${OrderLineKey}', OrderLineKey)
        doc = doc.replace('${OrderedQty}', OrderedQty)
        doc = doc.replace('${DocumentType}', DocumentType)
        doc = doc.replace('${OrderNo}', OrderNo)
    return doc

def generic_input_file_ord(folder_path,file_name,oh):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/'+file_name+'.xml'
    with open(tpath) as fd:
        doc = fd.read()
        doc = doc.replace('${OrderNo}', oh)
    return doc

def json_to_xml(json_obj, root_element):
    """
    Convert a JSON object to XML, recursively.
    """
    for key, value in json_obj.items():
        if isinstance(value, dict):
            # Create a new sub-element for each dictionary
            sub_element = ET.SubElement(root_element, key)
            json_to_xml(value, sub_element)
        elif isinstance(value, list):
            # If the value is a list, create elements for each item
            for item in value:
                sub_element = ET.SubElement(root_element, key)
                json_to_xml(item, sub_element)
        else:
            # If the value is a string or number, add it as text in the XML element
            root_element.set(key, str(value))


def convert_json_to_xml(json_data1):
    """
    Convert JSON string to XML format.
    """
    json_content = json.loads(json.dumps(json_data1))
    # Convert dictionary to a JSON string and write it to the file
    json_data = json.dumps(json_content)  # Convert dict to JSON string
    json_obj = json.loads(json_data)

    # Create the root element of the XML
    root_element = ET.Element("Root")

    # Convert the JSON to XML, starting from the root
    json_to_xml(json_obj, root_element)

    # Convert the XML tree to a string
    xml_str = ET.tostring(root_element, encoding="unicode", method="xml")

    # Format the XML (optional for readability)
    xml_str = minidom.parseString(xml_str).toprettyxml()

    return xml_str

def getOrderDetails_input_file2(order_no,Order_Header_Key,folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/getOrderDetails.xml'
    inner_template = string.Template(
        '    <Order DocumentType="${DocumentType}" EnterpriseCode="${EnterpriseCode}" OrderHeaderKey="${OrderHeaderKey}" OrderNo="${OrderNo}"></Order>')
    outer_template = string.Template("""
    ${document_list}
     """)
    # <ScheduleOrder  DocumentType="0001" EnterpriseCode="Liverpool" OrderHeaderKey="20241203090251475620" OrderNo="0904202401"/>
    data = [('0001', 'Liverpool', Order_Header_Key, order_no)]
    inner_contents = [inner_template.substitute(DocumentType=DocumentType, EnterpriseCode=EnterpriseCode,
                                                OrderHeaderKey=OrderHeaderKey, OrderNo=OrderNo) for
                      (DocumentType, EnterpriseCode, OrderHeaderKey, OrderNo) in data]
    result = outer_template.substitute(document_list='\n'.join(inner_contents))
    print(result)
    with open(tpath, 'w', newline='') as fd:
        fd.write(result)
        return result

def getOrderDetails_input_file(order_no,Order_Header_Key,folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/getOrderDetails.xml'
    with open(tpath) as fd:
        doc = fd.read()
        doc = doc.replace('$OrderNo', order_no)
        doc = doc.replace('$OrderHeaderKey', Order_Header_Key)
        tdirpath = folder_path1 + '/Input/getOrderDetailsInputWithOrderNo.xml'
    with open(tdirpath, 'w', newline='') as fd1:
            fd1.write(doc1)
    return json_content
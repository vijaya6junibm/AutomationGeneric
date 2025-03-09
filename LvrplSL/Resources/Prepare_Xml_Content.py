import json
import time
from datetime import datetime
import string
import xmltodict
import xml.etree.ElementTree as ET
import dicttoxml

def manage_item_with_dynamic_item1(folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/manageItemInputWithItemId.xml'
    with open(tpath) as fd:
        doc = fd.read()
        print('after mod', doc)
        doc1 = xmltodict.parse(doc)
        json_content = json.loads(json.dumps(doc1).replace("@", "_"))
        return json_content

def schedule_input_file1(order_no,Order_Header_Key,folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/scheduleOrder.xml'
    inner_template = string.Template(
        '    <ScheduleOrder DocumentType="${DocumentType}" EnterpriseCode="${EnterpriseCode}" OrderHeaderKey="${OrderHeaderKey}" OrderNo="${OrderNo}"></ScheduleOrder>')
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

def json_manage_item_file(folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/manageItemInput.xml'
    with open(tpath) as fd:
        doc = fd.read()
        dt = datetime.today().strftime('%Y%m%d%H%M%S')
        print('before mod', doc)
        doc = doc.replace('$ItemID', dt)
        tdirpath = folder_path1 + '/Input/manageItemInputWithItemId.json'
        with open(tdirpath, 'w', newline='') as fd1:
            doc1 = xmltodict.parse(doc)
            json_content = json.loads(json.dumps(doc1).replace("@", "_"))
            # Convert dictionary to a JSON string and write it to the file
            json_string = json.dumps(json_content, indent=4)  # Convert dict to JSON string
            fd1.write(json_string)
        print('after mod', json_string)
    return json_string

def manage_item_with_dynamic_item_ml(folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/manageItemInput.xml'
    with open(tpath) as fd:
        doc = fd.read()
        dt1 = dt1func()
        doc = doc.replace('$ItemID1', dt1)
        time.sleep(5)
        dt2 = dt2func()
        doc = doc.replace('$ItemID2', dt2)
        tdirpath = folder_path1 + '/Input/manageItemInputWithItemId.xml'
        with open(tdirpath, 'w', newline='') as fd1:
            fd1.write(doc)
        print('after mod', doc)
    return doc

def dt1func():
    dt1 = datetime.today().strftime('%Y%m%d%H%M%S')
    return dt1

def dt2func():
    time.sleep(2)
    dt2 = datetime.today().strftime('%Y%m%d%H%M%S')
    return dt2

def manage_item(folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/manageItemInput.xml'
    with open(tpath) as fd:
        doc = fd.read()
    return doc

def adjust_inventory_file(item_id,folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/adjInvInput.xml'
    tdirpath = folder_path1 + '/Input/adjInvInputWithItemId.xml'
    with open(tpath) as fd:
        doc = fd.read()
        doc = doc.replace('$ItemID', item_id)
    return doc

def fetch_item_ids(folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/manageItemInputWithItemId.xml'
    with open(tpath) as fd:
        doc = fd.read()
    root = ET.fromstring(doc)
    item_ids = [item.get('ItemID') for item in root.findall('.//Item')]
    return item_ids

def adjust_inventory_file_ml(folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/adjInvInput.xml'
    tdirpath = folder_path1 + '/Input/adjInvInputWithItemId.xml'
    with open(tpath) as fd:
        doc = fd.read()
        item_ids = fetch_item_ids(folder_path)
        item1 = item_ids[0]
        item2 = item_ids[1]
        doc = doc.replace('$ItemID1', item1)
        doc = doc.replace('$ItemID2', item2)
    return doc

def find_inventory_file(item_id,folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/findInvInput.xml'
    with open(tpath) as fd:
        doc = fd.read()
        doc = doc.replace('$ItemID', item_id)
    return doc

def find_inventory_file_ml(folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/findInvInput.xml'
    with open(tpath) as fd:
        doc = fd.read()
        item_ids = fetch_item_ids(folder_path)
        item1 = item_ids[0]
        item2 = item_ids[1]
        doc = doc.replace('$ItemID1', item1)
        doc = doc.replace('$ItemID2', item2)
    return doc

def create_order_file(item_id,folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/createOrderInput.xml'
    with open(tpath) as fd:
        doc = fd.read()
        doc = doc.replace('$ItemID', item_id)
        doc = doc.replace('$OrderNo', item_id)
    return doc

def create_order_file_ml(folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/createOrderInput.xml'
    with open(tpath) as fd:
        doc = fd.read()
        item_ids = fetch_item_ids(folder_path)
        item1 = item_ids[0]
        item2 = item_ids[1]
        doc = doc.replace('$ItemID1', item1)
        doc = doc.replace('$ItemID2', item2)
        doc = doc.replace('$OrderNo', item1)
    return doc

def write_output_file(output1,output,folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    with open(folder_path1 +'/Output/'+output+'.xml', 'w', newline='') as fd:
        fd.write(output1)

def getOrderDetails_input_file1(order_no,Order_Header_Key,folder_path):
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


def release_input_file1(order_no,Order_Header_Key,folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/ReleaseOrder.xml'
    inner_template = string.Template(
        '    <ReleaseOrder DocumentType="${DocumentType}" EnterpriseCode="${EnterpriseCode}" OrderHeaderKey="${OrderHeaderKey}" OrderNo="${OrderNo}"></ReleaseOrder>')
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

def somsns_input_file1(order_no, ItemID,folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/somsns.xml'
    inner_template = string.Template('    <OrderStatusChange OrderNo="${OrderNo}"><OrderLines><OrderLine ItemID=${ItemID} BaseDropStatus="CONF"></OrderLine></OrderLines></OrderStatusChange>')
    outer_template = string.Template("""
        ${document_list}
         """)
        #<OrderStatusChange OrderNo="OtestItem9a">
	#<OrderLines>
		#<OrderLine ItemID="testItem9a" BaseDropStatus="CONF"/>
	#</OrderLines>
#</OrderStatusChange>
    data = [('0001', 'Liverpool', ItemID, order_no)]
    inner_contents = [inner_template.substitute(DocumentType=DocumentType, EnterpriseCode=EnterpriseCode,
                                                    ItemID=ItemID, OrderNo=OrderNo) for
                          (DocumentType, EnterpriseCode, ItemID, OrderNo) in data]
    result = outer_template.substitute(document_list='\n'.join(inner_contents))
    print(result)
    with open(tpath, 'w', newline='') as fd:
        fd.write(result)
    return result

def backorder_input_file1(order_no, ItemID,folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/backorder.xml'
    inner_template = string.Template(
        '    <Reject  Cantidad="1.000" Descripcion="INVEN VAD por medio de la interfaz" Motivo="BOCE Mercancía Extraviada" Nodo="127" Odo="" Orden="${OrderNo}" Sku="${ItemID}" Usuario="ESANDOVAL"/>')
    outer_template = string.Template("""
        ${document_list}
         """)
        #<OrderStatusChange OrderNo="OtestItem9a">
	#<OrderLines>
		#<OrderLine ItemID="testItem9a" BaseDropStatus="CONF"/>
	#</OrderLines>
#</OrderStatusChange>
    data = [(ItemID, order_no)]
    inner_contents = [inner_template.substitute(ItemID=ItemID, OrderNo=OrderNo) for
                          (ItemID, OrderNo) in data]
    result = outer_template.substitute(document_list='\n'.join(inner_contents))
    print(result)
    with open(tpath, 'w', newline='') as fd:
        fd.write(result)
    return result

def input_file(item_id,folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/input.xml'
    with open(tpath) as fd:
        doc = fd.read()
        doc = doc.replace('$ItemID', item_id)
    return doc

def input_file1(folder_path):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/Input.xml'
    with open(tpath) as fd:
        doc = fd.read()
    return doc

def generic_input_file(item_id,folder_path,file_name):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/'+file_name+'Input.xml'
    with open(tpath) as fd:
        doc = fd.read()
        doc = doc.replace('$ItemID', item_id)
    return doc

def generic_input_file1(folder_path,file_name):
    folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
    tpath = folder_path1 + '/Input/'+file_name+'Input.xml'
    with open(tpath) as fd:
        doc = fd.read()
    return doc

def dict_to_xml(dictionary):
    return dicttoxml.dicttoxml(dictionary).decode()
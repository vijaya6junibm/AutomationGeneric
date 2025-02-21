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
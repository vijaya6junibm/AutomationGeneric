import json
import os

import xmltodict

# Variables
base_path = 'Tests/'
file_name = 'Input/input.xml'

# Using os.path.join()
file_path = os.path.join(base_path, file_name)

def read_req_content_find_inv1():
    with open('C:/EplAutomation/LvrplAutomn/LvrplAuto/Data/sample.xml') as fd:
        doc = xmltodict.parse(fd.read())
    json_content = json.loads(json.dumps(doc).replace("@", "_"))
    print('read_req_content1 sample xml file')
    print(json_content)
    return json_content


def request_find_inventory_tc001_sl1():
    with open('C:/EplAutomation/LvrplAutomn/LvrplAuto/Data/input_TC001_Sl1.xml') as fd:
        doc = xmltodict.parse(fd.read())
    json_content = json.loads(json.dumps(doc).replace("@", "_"))
    print('read_req_content1 sample xml file')
    print(json_content)
    return json_content

def request_find_inventory_tc001_sl1a():
    with open('C:/EplAutomation/LvrplAutomn/LvrplAuto/Data/input_TC001_Sl1a.xml') as fd:
        doc = xmltodict.parse(fd.read())
    json_content = json.loads(json.dumps(doc).replace("@", "_"))
    print('read_req_content1 sample xml file')
    print(json_content)
    return json_content

#Create_Order_TC_001.robot
def request_create_order_tc001_seq1_copy1():
    absolute_path = os.path.dirname(__file__)
    #absolute_path = os.path.relpath("../Input","input.xml")
    relative_path = "/Input/input.xml"
    full_path = os.path.join(absolute_path, relative_path)
    with open(full_path) as fd:
        doc = fd.read()
    print('read_req_content1 sample xml file')
    print(doc)
    return doc

def request_create_order_tc001_seq1():
    with open('C:/EPL-Liverpool-SL/CreateOrder/TC_001_CreateOrderPos - create normal order/Input/input.xml') as fd:
        doc = fd.read()
    print('read_req_content1 sample xml file')
    print(doc)
    return doc

def request_create_order_tests_tc001_seq1():
    with open('C:/EPL-Liverpool-SL/CreateOrder/Tests/Input/input.xml') as fd:
        doc = fd.read()
    print('read_req_content1 sample xml file')
    print(doc)
    return doc

def request_create_order_tc001_seq1_copy():
    upload_folder = os.path.abspath("Input/input.xml")
    with open(upload_folder) as fd:
        doc = fd.read()
    print('read_req_content1 sample xml file')
    print(doc)
    return doc

def request_create_order_tc001_seq2():
    with open('C:/EplAutomation/LvrplAutomn/LvrplAuto/Data/createOrderSeq2.xml') as fd:
        doc = xmltodict.parse(fd.read())
    print('read_req_content1 sample xml file')
    print(doc)
    return doc

def request_find_inventory_tc001_sl1b():
    with open('C:/EplAutomation/LvrplAutomn/LvrplAuto/Data/input_TC001_Sl1b.xml') as fd:
        doc = xmltodict.parse(fd.read())
    json_content = json.loads(json.dumps(doc).replace("@", "_"))
    print('read_req_content1 sample xml file')
    print(json_content)
    return json_content


def manage_item_find_inv_sl1():
    with open('C:/EplAutomation/LvrplAutomn/LvrplAuto/Data/manageItemSL1.xml') as fd:
        doc = xmltodict.parse(fd.read())
    json_content = json.loads(json.dumps(doc).replace("@", "_"))
    print('read_req_content1 sample xml file')
    print(json_content)
    return json_content

def manage_item_find_inv_seq1():
    with open('C:/EplAutomation/LvrplAutomn/LvrplAuto/Data/manageItemSeq1.xml') as fd:
        doc = xmltodict.parse(fd.read())
    json_content = json.loads(json.dumps(doc).replace("@", "_"))
    print('read_req_content1 sample xml file')
    print(json_content)
    return json_content

def flash_test1():
    with open('C:/EplAutomation/LvrplAutomn/LvrplAuto/Data/flash1.xml') as fd:
        doc = xmltodict.parse(fd.read())
    json_content = json.loads(json.dumps(doc).replace("@", "_"))
    print('read_req_content1 sample xml file')
    print(json_content)
    return json_content

x=request_create_order_tc001_seq1()
print(x)
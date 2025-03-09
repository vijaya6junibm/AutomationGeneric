import json
import os

import xmltodict
from selenium.webdriver.common.bidi.console import Console
from datetime import datetime


#Create_Order_TC_001.robot
def request_create_order_pos_tc001_seq1():
    with open('C:/EPL-Liverpool-SL/CreateOrder/TC_001_CreateOrderPos - create normal order/Input/input.xml') as fd:
        doc = fd.read()
    return doc

def request_create_order_tests_tc001_seq1():
    with open('C:/EPL-Liverpool-SL/CreateOrder/TC_002_CreateOrderPos - create normal order ClickandCollect/Input/input.xml') as fd:
        doc = fd.read()
    return doc

def request_create_order_app_tc003():
    with open('C:/EPL-Liverpool-SL/CreateOrder/TC_003_CreateOrderApp - create normal order/Input/input.xml') as fd:
        doc = fd.read()
    return doc


def create_order(dirpath,path1,itemId):
    with open(dirpath+'/'+path1+'/Input/CreateOrderInput.xml') as fd:
        print('abc')
        doc = fd.read()
        doc = doc.replace('$ItemID', itemId)
        with open(dirpath + '/' + path1 + '/Input/inputWithOrderId.xml', 'w', newline='') as fd:
            fd.write(doc)
        print(doc)
    return doc

def create_order_with_dynamic_item(dirpath,path1):
    with open(dirpath+'/'+path1+'/Input/inputWithItemId.xml') as fd:
        doc = xmltodict.parse(fd.read())
        json_content = json.loads(json.dumps(doc).replace("@", "_"))
        print(json_content)
    return json_content
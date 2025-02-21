import json
import os

import xmltodict
from selenium.webdriver.common.bidi.console import Console
from datetime import datetime

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
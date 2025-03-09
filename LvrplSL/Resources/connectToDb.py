import os

from pandas.io.formats.format import return_docstring
from sqlalchemy.engine import cursor

os.add_dll_directory('C:\\pythonInst\\Lib\\site-packages\\clidriver\\bin')
import ibm_db

# Define connection parameters
hostname = 'localhost'
port = '50000'  # Default DB2 port is usually 50000
db_name = 'OMDB'
user = 'db2inst1'
password = 'diet4coke'
json_itemid1 = '20250128180616'

# Create the connection string
dsn = f"DATABASE={db_name};HOSTNAME={hostname};PORT={port};UID={user};PWD={password};"

# Establish the connection
conn1 = ibm_db.connect(dsn, user, password)

if conn1:
    print("Connected to Db2 database!")
    sql_item = "select inventory_activity_key from omdb.yfs_inventory_activity where inventory_item_key in (select inventory_item_key from omdb.yfs_inventory_item where item_id = '" + json_itemid1 + "')""and node_key = '113' order by modifyts desc;"
    # Example: Execute a query
    #sql = "SELECT * FROM omdb.yfs_item"
    #sql = "SELECT SHORT_DESCRIPTION FROM omdb.yfs_item WHERE ITEM_ID = '202501171132'"
    sql = (sql_item)
    print('this is sql')
    print(sql)
    stmt = ibm_db.exec_immediate(conn1, sql)

    # Fetch and display results
    result = ibm_db.fetch_assoc(stmt)
    print(result)
    while result:
        print('*******************************8')
        result = ibm_db.fetch_assoc(stmt)
        print(result)

    # Close the connection
    ibm_db.close(conn1)
else:
    print("Failed to connect to Db2 database.")

def check_inventory_activity(json_itemid,folder_path):
    dict_str2 = ""
    conn = ibm_db.connect(dsn, user, password)

    if conn:
        print("Connected to Db2 database!")
        #sql1 = "SELECT SHORT_DESCRIPTION FROM omdb.yfs_item WHERE ITEM_ID = '202501171132'"
        sql1 = (
                "select inventory_activity_key from omdb.yfs_inventory_activity where inventory_item_key in (select inventory_item_key from omdb.yfs_inventory_item where item_id = '" + json_itemid + "')"                                                                                                                                                                                             "and node_key = '113' order by modifyts desc;")
        stmt1 = ibm_db.exec_immediate(conn, sql1)
        # Fetch and display results
        result1 = ibm_db.fetch_assoc(stmt1)
        print(result1)
        dict_str2 = str(result1)
        folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
        tpath = folder_path1 + '/Input/getItem1.txt'
        with open(tpath, 'w', newline='') as fd:
            fd.write(dict_str2)
    return dict_str2


def execute_sql_stmt(sql_stmt,folder_path):
    dict_str2 = ""
    conn = ibm_db.connect(dsn, user, password)

    if conn:
        print("Connected to Db2 database!")
        #sql1 = "SELECT SHORT_DESCRIPTION FROM omdb.yfs_item WHERE ITEM_ID = '202501171132'"
        sql1 = (sql_stmt)
        stmt1 = ibm_db.exec_immediate(conn, sql1)
        # Fetch and display results
        result1 = ibm_db.fetch_assoc(stmt1)
        print(result1)
        dict_str2 = str(result1)
        folder_path1 = "\\".join(folder_path.split("\\")[0:-1])
        tpath = folder_path1 + '/Input/getItem1.txt'
        with open(tpath, 'w', newline='') as fd:
            fd.write(dict_str2)
    return dict_str2
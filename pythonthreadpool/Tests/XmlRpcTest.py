from TestTiming import time_this
from thread import start_new_thread 
from xmlrpclib import ServerProxy
import logging

PORT_NUMBER = 20392 

logging.basicConfig(level=logging.DEBUG,
                format='%(asctime)s %(levelname)-8s thread: %(thread)d %(name)-5s %(message)s',
                datefmt='%a, %d %b %Y %H:%M:%S')

def test_method():
    #logging.info("test_method")
    return True

def setup(xml_rpc_server):
    xml_rpc_server.register_function(test_method, "test")
    start_new_thread(xml_rpc_server.serve_forever, ())

def call_test():
    client = ServerProxy('http://localhost:%i'%PORT_NUMBER)
    client.test()

def run_test():
    for _ in range(0,5000):
        call_test()
        

def do_test(xml_rpc_server):
    setup(xml_rpc_server)

    logging.info("timed call %f"%time_this(call_test, True))
    logging.info("timed call %f"%time_this(run_test, True))
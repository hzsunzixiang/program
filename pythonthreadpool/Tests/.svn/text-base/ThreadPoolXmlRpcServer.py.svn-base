from XmlRpcTest import do_test, PORT_NUMBER
from SimpleXMLRPCServer import SimpleXMLRPCServer
from ThreadPool import ThreadPoolMixIn

class XmlRpcServerThreadPool(ThreadPoolMixIn, SimpleXMLRPCServer):
    def __init__(self):
        SimpleXMLRPCServer.__init__ (self, ('localhost', PORT_NUMBER), logRequests=False)
        ThreadPoolMixIn.__init__(self)

do_test(XmlRpcServerThreadPool())
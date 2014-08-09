from XmlRpcTest import do_test, PORT_NUMBER
from SimpleXMLRPCServer import SimpleXMLRPCServer
from SocketServer import ThreadingMixIn

class XmlRpcServer(ThreadingMixIn, SimpleXMLRPCServer):
        
    def __init__(self):
        SimpleXMLRPCServer.__init__ (self, ('localhost', PORT_NUMBER), logRequests=False)

do_test(XmlRpcServer())




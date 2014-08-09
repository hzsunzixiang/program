#!/usr/bin/env python
# -*- coding: utf8 -*-

from optparse import OptionParser  

parser = OptionParser()  
#parser.add_option("-f", "--file", dest="filename",  
#                  help="write report to FILE", metavar="FILE")  
parser.add_option("-f", "--file",  
                          action="store", type="string", dest="filename") 
parser.add_option("-q", "--quiet",  
                  action="store_false", dest="verbose", default=True,  
                  help="don't print status messages to stdout")  
  
args = ["-f", "foo.txt"] 
(options, args) = parser.parse_args(args)  
print options.filename

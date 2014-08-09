#!/usr/bin/env python
# -*- coding: utf8 -*-
from optparse import OptionParser
import optparse
import os
import pdb

debug=True
#debug=False

def check_file(option, opt, value, parser):
    if not os.path.exists(value):
        raise optparse.OptionValueError("%s doesn't seem to exist." % value)
    print  value
    parser.values.inputfile = value
    print  value

def check_filex(value,option):
    print  "xxxx"+str(value)
if debug:
    pdb.set_trace()
parser = optparse.OptionParser()
parser.add_option("-f", "--input-file", dest="inputfile",
                  action="callback", callback=check_file,
                  type="string", help="The file with input")
(options, arguments) = parser.parse_args()
#这里可以看出来这个名字是任意的 ,和上面的inputfile是等价的
setattr(parser.values, "actionxxx", check_filex)
setattr(parser.values, "action_args", "callback.py")
print "parser.values"+str( parser.values)
parser.values.actionxxx(parser.values.action_args, options)


print options

#python callback.py -f prog.py

#prog.py
#prog.py
#parser.values{'actionxxx': <function check_filex at 0x25ac9b0>, 'action_args': 'callback.py', 'inputfile': 'prog.py'}
#xxxxcallback.py
#{'actionxxx': <function check_filex at 0x25ac9b0>, 'action_args': 'callback.py', 'inputfile': 'prog.py'}


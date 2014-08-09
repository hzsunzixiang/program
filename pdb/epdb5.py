#!/usr/bin/env Python

                
import pdb 
from function import combine
#_debug=True
_debug=False
a = "aaa"
if _debug:
    pdb.set_trace() 
b = "bbb"
c = "ccc"
final = combine(a,b) 
print final

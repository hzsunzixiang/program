#!/usr/bin/env Python

#When invoked as a script, pdb will automatically enter post-mortem debugging 
#if the program being debugged exits abnormally. After post-mortem debugging 
#(or after normal exit of the program), pdb will restart the program. 
#Automatic restarting preserves pdb’s state (such as breakpoints) and in most cases 
#is more useful than quitting the debugger upon program’s exit.
#                
import pdb 
from function import combine
#_debug=True
_debug=False
a = "aaa"
if _debug:
    pdb.set_trace() 
b = "bbb"
c = "ccc"
print notExist 
final = combine(a,b) 
print final

#!/usr/bin/env Python

                
import pdb 
def combine(s1,s2):      # define subroutine combine, which... 
   s3 = s1 + s2 + s1    # sandwiches s2 between copies of s1, ... 
   s3 = '"' + s3 +'"'   # encloses it in double quotes,... 
   pdb.set_trace() 
   return s3            # and returns it. 
a = "aaa"
pdb.set_trace() 
b = "bbb"
pdb.set_trace() 
c = "ccc"
pdb.set_trace() 
final = combine(a,b) 
pdb.set_trace() 
print final

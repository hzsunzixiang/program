#!/usr/bin/env python
# -*- coding:UTF-8

def debug_log(f):
 
  def wrapper(*args, **kwargs):
      print 'enter into %s' %  f.__name__
      print args
      print kwargs
      f(*args, **kwargs)
      print 'leaving %s' % f.__name__
 
  return wrapper
 
@debug_log
def test():
    print 'hello'

@debug_log
def test1(a=2,b=3,c=4,d=5):
    print 'hello'

test()
test1(2,3,c=4)

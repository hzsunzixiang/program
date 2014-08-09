#!/usr/bin/env python
# -*- coding:UTF-8
#coding=gbk
import httplib
conn = httplib.HTTPConnection("www.google.cn")
conn.request('get', '/')
print conn.getresponse().read()
conn.close()

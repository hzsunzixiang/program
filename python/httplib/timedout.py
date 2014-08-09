#!/usr/bin/env python
# -*- coding:UTF-8
#coding=gbk
import httplib
import traceback

try:
    conn = httplib.HTTPConnection("www.google.cn",timeout=0.005)
    conn.request('GET', '/')
    print conn.getresponse().read()
    conn.close()
except Exception,e:
    errMsg = traceback.format_exc()
    print " attachVolumeByThread: %s:%s" % (str(e), errMsg)


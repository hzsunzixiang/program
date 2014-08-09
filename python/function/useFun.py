#! /usr/bin/env python
 
import threading
import time
def rollbackLibVirtAttachDisk(param):
    '''回滚libvirt　attach disk的操作，
    @param param 存储了操作过程中多个参数的一个列表
    '''

    try:
        virtCtrl = param[0]
        vmInstanceId = param[1]
        hostDevice = param[2]
        virtCtrl.detachDisk(vmInstanceId, hostDevice)
    except Exception, e:
        HostAgentLogger.error("rollback failed: %s " % str(e) 

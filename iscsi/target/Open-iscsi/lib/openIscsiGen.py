# -*- coding:UTF-8


import sys
import time
import os
import math
# import shutil
import traceback
import threading
import glob
import pdb

from HostAgentExec import *
from HostAgentLib  import *
from KVStore import KVStore
from HostAgentConfig import HostAgentConfig
from HostAgentLogger import HostAgentLogger




class ActionRollback:
    '''仿真事务的一个类
    当执行一些操作时，需要执行很多个步骤，当执行到一个中间的步骤失败时，需要回滚前面的步骤
    '''

    def __init__(self):
        self.actions = []

    def rollback(self):
        '''回滚操作
        '''

        for action in self.actions[::-1]:
            action[0](action[1])

def rollbackIscsiLogin(param):
    '''回滚iscsi login的操作，即执行logout的操作
    @param param 存储了操作过程中多个参数的一个列表
    '''

    try:
        osCmd = "iscsiadm -m node -T %s -p %s:%d --logout" % (param[0], param[1], param[2])
        runExec(osCmd)
    except Exception, e:
        HostAgentLogger.error("rollback failed: %s " % str(e))

def actionIscsiLogin(rollback, param):
    '''iscsi login的操作
    
    @param rollback 记录回滚操作
    @param param 存储了操作过程中多个参数的一个列表: (TargetName, ip, port, chapUser, chapPass)
    '''

    osCmd = "iscsiadm -m discovery -t st -p %s:%d" % (param[1], param[2])
    runExec(osCmd)

    osCmd = "iscsiadm -m node -T %s --op=update --name=node.session.auth.authmethod --value=CHAP" % (param[0])
    runExec(osCmd)

    osCmd = "iscsiadm -m node -T %s --op=update --name=node.session.auth.username --value=%s" % (param[0], param[3])
    runExec(osCmd)

    osCmd = "iscsiadm -m node -T %s --op=update --name=node.session.auth.password --value=%s" % (param[0], param[4])
    runExec(osCmd)

    osCmd = "iscsiadm -m node -T %s -p %s:%d -l" % (param[0], param[1], param[2])
    runExec(osCmd)
    rollback.actions.append((rollbackIscsiLogin, param))
    
def iscsiLoginRetry( targetName, ip, port, chapUser, chapPass):
    '''iscsi login的操作
    
    @param rollback 记录回滚操作
    @param param 存储了操作过程中多个参数的一个列表: (TargetName, ip, port, chapUser, chapPass)
    '''

    osCmd = "iscsiadm -m discovery -t st -p %s:%d" % (ip, port)
    runExec(osCmd)

    osCmd = "iscsiadm -m node -T %s --op=update --name=node.session.auth.authmethod --value=CHAP" % (targetName)
    runExec(osCmd)

    osCmd = "iscsiadm -m node -T %s --op=update --name=node.session.auth.username --value=%s" % (targetName, chapUser)
    runExec(osCmd)

    osCmd = "iscsiadm -m node -T %s --op=update --name=node.session.auth.password --value=%s" % (targetName, chapPass)
    runExec(osCmd)

    osCmd = "iscsiadm -m node -T %s -p %s:%d -l" % (targetName, ip, port)
    runExec(osCmd)
    


class HostAgentServiceHandler:
    def __init__(self):
        pass

    def purgeIscsiTarget(self, iscsiTargetList):
        for target in iscsiTargetList:
            osCmd = "iscsiadm -m node -T %s --logout" % (target)
            try:
                runExec(osCmd)
            except Exception, e:
                HostAgentLogger.info(str(e))
#  729  iscsiadm -m node -T  $iqn --op=update --name=node.session.auth.authmethod --value=CHAP
#  730  iscsiadm -m node -T  $iqn --op=update --name=node.session.auth.username --value=nbs
#  731  iscsiadm -m node -T  $iqn --op=update --name=node.session.auth.password --value=netease
#  732  iscsiadm -m node -T  $iqn -p 192.168.146.26:3260 -l

def loginIscsiTarget(device):
    targetName='test:123456:%s'%(device)
    ip='10.120.37.8'
    port=3260
    chapUser='nbs'
    chapPass='netease'
    #iscsiadm -m session -P3
    try:
        iscsiLoginRetry( targetName, ip, port, chapUser, chapPass)
    except Exception, e:
        errMsg = traceback.format_exc()
        HostAgentLogger.critical(errMsg)
        print "login %s"%(errMsg)
def logoutIscsiTarget(device):
    try:
        targetName='test:123456:%s'%(device)
        osCmd = "iscsiadm -m node -T %s --logout" % (targetName)
        runExec(osCmd)
    except Exception, e:
        errMsg = traceback.format_exc()
        HostAgentLogger.critical(errMsg)
        print "logout %s"%(errMsg)
def sshCmd(ip, user, cmd, device):
    #osCmd = '''ssh -i  ~/.ssh/key %s@%s "python /home/nbs/program/iscsi/0.6/VolumeServer/lib/sendTarget.py %s"'''%(user,ip,cmd)
    osCmd = '''ssh -i  ~/.ssh/key %s@%s "python /root/nbs-environ/0.6/VolumeServer/lib/sendtarget.py %s %s"'''%(user,ip,cmd,device)
    runExec(osCmd)
#DEBUG=False
DEBUG=True
if __name__ == "__main__":
    #HostAgentConfig.loadConfig()
    HostAgentLogger.initLogger()
    if DEBUG:
        pdb.set_trace()
    if cmp(sys.argv[1],'login')==0:
        loginIscsiTarget(sys.argv[2])
        print "login success" 
    if cmp(sys.argv[1],'logout')==0:
        logoutIscsiTarget(sys.argv[2])
##DEBUG=True
#DEBUG=False
#if __name__ == "__main__":
#    #HostAgentConfig.loadConfig()
#    HostAgentLogger.initLogger()
#    if DEBUG:
#        pdb.set_trace()
#    while True:
#        sshCmd("10.120.37.8","root","send",sys.argv[1])
#        print "send target success" 
#        loginIscsiTarget(sys.argv[1])
#        print "login success" 
#        time.sleep(2)
#        logoutIscsiTarget(sys.argv[1])
#        print "logout success" 
#        sshCmd("10.120.37.8","root","purge",sys.argv[1])
#        print "purge target success" 

# -*- coding:UTF-8


import sys
import time
import os
import traceback
import threading
import pdb

from iSCSIExec import *
#from VSLib  import *

from iSCSILogger import iSCSILogger
from iSCSIExec import runExec
import configure




class TargetInfo:
  """
  Attributes:
   - targetName
   - targetPort
   - chapUser
   - chapPass
  """

  def __init__(self, targetName=None, targetPort=None, chapUser=None, chapPass=None,):
    self.targetName = targetName
    self.targetPort = targetPort
    self.chapUser = chapUser
    self.chapPass = chapPass

class ActionRollback:
    '''仿真事务的一个类
    当执行一些操作时，需要执行很多个步骤，当执行到一个中间的步骤失败时，需要回滚前面的步骤
    '''

    def __init__(self):

        # 操作列表
        self.actions = []

    def rollback(self):
        '''回滚操作
        '''
        for action in self.actions[::-1]:
            action[0](action[1])

def rollbackTcmCreate(param):
    '''定义创建lio中tcm后端存储的回滚操作
    @param param 存储了创建lio中tcm的多个参数的一个列表 (前缀,硬盘名)
    '''
    lioCfgDir = "/sys/kernel/config/target/core/iblock_0/%s_%s" % (param[0], param[1])
    if os.path.exists(lioCfgDir):
        try:
            osCmd = "tcm_node --freedev iblock_0/%s_%s" % (param[0], param[1])
            runExec(osCmd)
        except Exception, e:
            iSCSILogger.error("rollback tcm_node %s_%s failed: %s " % (param[0], param[1], str(e)))

def actionTcmCreate(rollback, param):
    '''执行tcm_node --block iblock_0/<bs_name> <block_dev>
    
    @param rollback 回滚类的一个实例
    @param param 存储了创建lio中tcm的多个参数的一个列表, (前缀,硬盘名)
    '''
    osCmd = "tcm_node --block iblock_0/%s_%s /dev/%s" % (param[0], param[1], param[1])
    runExec(osCmd)
    rollback.actions.append((rollbackTcmCreate, param))

def rollbackLioAddLun(param):
    '''lio中增加lun的回滚函数
    @param param 存储了lio中增加lun的多个参数的一个列表
    '''

    osCmd = "lio_node --deliqn=%s" % param[0]
    try:
        runExec(osCmd)
    except Exception, e:
        iSCSILogger.error("rollback failed: run %s failed : %s " % (osCmd, repr(e)))

def actionLioAddLun(rollback, param):
    '''lio中增加lun
    
    @param rollback 回滚类的一个实例
    @param param 存储了lio中增加lun的多个参数的一个列表  (targetName, 前缀, lvName)
    '''

    osCmd = "lio_node --addlun %s 1 0 iscsi00 iblock_0/%s_%s" % (param[0], param[1], param[2])
    runExec(osCmd)
    rollback.actions.append((rollbackLioAddLun, param))


class ISCSIHandler:
    ''' 
    '''

    def __init__(self):
        pass

    # 清理target中iscsi的配置
    def  purgeIscsi(self, targetName):
        '''清理LIO中的iscsi target
        
        @param targetName Iscsi target名称
        '''

        cfgIscsiFile = "/sys/kernel/config/target/iscsi/%s" % (targetName)
        if os.path.exists(cfgIscsiFile):
            osCmd = "lio_node --deliqn=%s" % (targetName)
            try:
                runExec(osCmd)
            except Exception:
                pass
    def purgeIqn(self, targetName):
        '''清理LIO中的iscsi target
        @param targetName Iscsi target名称
        '''

        cfgIscsiFile = "/sys/kernel/config/target/iscsi/%s" % (targetName)
        if os.path.exists(cfgIscsiFile):
            osCmd = "lio_node --deltpg %s 1" % (targetName)
            try:
                runExec(osCmd)
            except Exception:
                pass

    # 清理target中tcm的配置
    def purgeTcm(self, lvName):
        '''清理LIO中tcm的配置
        
        @param lvName 逻辑卷名称
        '''
        lioCfgDir = "/sys/kernel/config/target/core/iblock_0/%s_%s" % ("test", lvName)
        if os.path.exists(lioCfgDir):
            try:
                osCmd = "tcm_node --freedev iblock_0/%s_%s" % ("test", lvName)
                runExec(osCmd)
            except Exception:
                pass

    def sendTarget(self, lvName, initiatorName):
        '''输出Target
        @param lvName 输出target 
        @param initiatorName 允许访问此逻辑卷的iscsi initor的名称
        @return 返回一个TargetInfo的结构体
        '''
        iSCSILogger.info("Call interface sendTarget(%s, %s)..." % (lvName, initiatorName))

        try:
            rollback = ActionRollback()
            # 执行 tcm_node --block iblock_0/%s_%s /dev/%s" % (param[0], param[1], param[1])
            actionTcmCreate(rollback, ('test', lvName))
            # 定义iqn前缀
            iqn ="test"
            # 组装targetName iqn+ 倒装域名 + lvName
            #targetName = "%s:%d:%s" % (iqn, time.time() * 1000, lvName)
            targetName = "%s:%d:%s" % (iqn, 123456, lvName)
            targetInfo = TargetInfo()
            targetInfo.targetName = targetName
            #targetInfo.targetPort = VSConfig.getIscsiPort()
            targetInfo.chapUser = 'nbs'
            #targetInfo.chapPass = getRandomPass()
            targetInfo.chapPass = 'netease'
            # 执行  lio_node --addlun %s 1 0 iscsi00 iblock_0/%s_%s" %(targetName, VSConfig.getVgName(), lvName)
            actionLioAddLun(rollback, (targetName, 'test', lvName))
            osCmd = "lio_node --addnp %s 1 %s:%d" % (targetName, "0.0.0.0",3260)
            runExec(osCmd)
            osCmd = "lio_node --enableauth %s 1" % (targetName)
            runExec(osCmd)
            osCmd = "lio_node --addlunacl %s 1 %s 0 0" % (targetName, initiatorName)
            runExec(osCmd)
            osCmd = "lio_node --setchapauth %s 1 %s %s %s" % (targetName, initiatorName, targetInfo.chapUser, targetInfo.chapPass)
            runExec(osCmd)
            osCmd = "lio_node --settpgattr=%s 1 cache_dynamic_acls 0" % (targetName)
            runExec(osCmd)
            osCmd = "lio_node --enabletpg %s 1" % (targetName)
            runExec(osCmd)
            print "sendTarget success"
            iSCSILogger.info("sendTarget success")
        except Exception, e:
            errMsg = traceback.format_exc()
            rollback.rollback()
            iSCSILogger.error(errMsg)
            raise Exception
        return targetInfo

    def cleanTarget(self, lvName, targetName):
        # 先后顺序很重要，
        self.purgeIqn(targetName)    #  lio_node --deltpg
        iSCSILogger.info("purgeIqn success")
        print "purgeIqn success"
        self.purgeTcm(lvName)        #  tcm_node --freedev 
        iSCSILogger.debug("purgeTcm success")
        print "purgeTcm success"
        self.purgeIscsi(targetName)  #  lio_node --deliqn=
        iSCSILogger.debug("purgeIscsi success")
        print "purgeIscsi success"
def startTarget(lvName):
    initiatorName = "iqn.1993-08.org.debian:01:fcc9228c36cc"
    #initiatorName = configure.initiatorName
    iqn ="test"
    targetName = "%s:%d:%s" % (iqn, 123456, lvName)
    handler = ISCSIHandler()
    try:
        handler.sendTarget(lvName, initiatorName)
        print "sendTarget success"
        iSCSILogger.debug("sendTarget success")
        #time.sleep(1)
        #handler.cleanTarget(lvName,targetName)
    except Exception, e:
        handler.cleanTarget(lvName,targetName)
        handler.sendTarget(lvName, initiatorName)
        errMsg = traceback.format_exc()
        iSCSILogger.critical(errMsg)
def purgeTarget(lvName):
    iqn ="test"
    targetName = "%s:%d:%s" % (iqn, 123456, lvName)
    handler = ISCSIHandler()
    try:
        handler.cleanTarget(lvName,targetName)
        print "purgeTarget success"
        iSCSILogger.debug("purgeTarget success")
    except Exception, e:
        errMsg = traceback.format_exc()
        iSCSILogger.critical(errMsg)

if __name__ == "__main__":

        iSCSILogger.initLogger()

        for arg in sys.argv:
            print arg
        #  python /root/program/iscsi/Open-iscsi/lib/sendtarget.py send loop1
        if cmp(sys.argv[1],'send')==0:
            startTarget(sys.argv[2])
        #  python /root/program/iscsi/Open-iscsi/lib/sendtarget.py purge loop1
        elif cmp(sys.argv[1],'purge')==0:
            purgeTarget(sys.argv[2])

#        while True:
#            try:
#                startTarget("loop1")
#                print "sendTarget success"
#                iSCSILogger.debug("sendTarget success")
#                #time.sleep(1)
#                purgeTarget("loop1")
#            except Exception, e:
#                purgeTarget("loop1")
#                errMsg = traceback.format_exc()
#                iSCSILogger.critical(errMsg)







# -*- coding:UTF-8


import sys
import time
import os
import traceback
import threading
import pdb

from VSExec import *
from VSLib  import *

from VSConfig import VSConfig
from VSLogger import VSLogger
from VSTaskManager import *

from vsservice import VSService
from vsservice.ttypes import *




class VSActionRollback:
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
    @param param 存储了创建lio中tcm的多个参数的一个列表
    '''

    lioCfgDir = "/sys/kernel/config/target/core/iblock_0/%s_%s" % (param[0], param[1])
    if os.path.exists(lioCfgDir):
        try:
            osCmd = "tcm_node --freedev iblock_0/%s_%s" % (param[0], param[1])
            runExec(osCmd)
        except Exception, e:
            VSLogger.error("rollback tcm_node %s_%s failed: %s " % (param[0], param[1], str(e)))

def actionTcmCreate(rollback, param):
    '''执行tcm_node --block iblock_0/<bs_name> <block_dev>
    
    @param rollback 回滚类的一个实例
    @param param 存储了创建lio中tcm的多个参数的一个列表
    '''

    #osCmd = "tcm_node --block iblock_0/%s_%s /dev/%s/%s" % (param[0], param[1], param[0], param[1])
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
        VSLogger.error("rollback failed: run %s failed : %s " % (osCmd, repr(e)))

def actionLioAddLun(rollback,param):
    '''lio中增加lun
    
    @param rollback 回滚类的一个实例
    @param param 存储了lio中增加lun的多个参数的一个列表
    '''
    #--addlun=TARGET_IQN TPGT LUN PORT_ALIAS TCM_HBA/DEV

    osCmd = "lio_node --addlun %s %d %d iscsi00 iblock_0/%s_%s" % (param[0],param[1], param[2],param[3],param[4])
    runExec(osCmd)
    rollback.actions.append((rollbackLioAddLun, param))


class VSServiceHandler:
    '''Volume Server的thrift服务接口的处理类
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
    def purgeIqn(self, targetName,tpgt):
        '''清理LIO中的iscsi target
        
        @param targetName Iscsi target名称
        '''

        cfgIscsiFile = "/sys/kernel/config/target/iscsi/%s" % (targetName)
        #--deltpg=TARGET_IQN TPGT
        if os.path.exists(cfgIscsiFile):
            osCmd = "lio_node --deltpg %s %d" % (targetName,tpgt)
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

    def __purgeAttachLV(self, lvName):
        '''卸载逻辑卷
        
        @param lvName 逻辑卷名称
        '''

        targetList = getTargetList(VSConfig.getHost())
        for target in targetList:
            cells = target.split(':')
            if cells[-1] == lvName:
                self.__purgeIscsi(target)
        self.__purgeTcm(lvName)

    def __lvIsAttached(self, lvName):
        '''检测逻辑卷是否已挂载
        
        @param lvName 逻辑卷名称
        @return 已挂载返回１,未挂载返回０
        '''


        lioCfgDir = "/sys/kernel/config/target/core/iblock_0/%s_%s" % (VSConfig.getVgName(), lvName)
        if os.path.exists(lioCfgDir):
            return 1
        else:
            return 0


    def sendTarget(self, lvName,tpgt,lun, initiatorName,suffix):
        '''服务接口，挂载逻辑卷
        
        @param lvName 输出target 
        @param initiatorName 允许访问此逻辑卷的iscsi initor的名称
        @return 返回一个TargetInfo的结构体
        '''

        VSLogger.info("Call interface attachLV(%s, %s)..." % (lvName, initiatorName))

        try:
            rollback = VSActionRollback()
            actionTcmCreate(rollback, ('test', lvName))
            #iqn = dnsName2IQN(VSConfig.getHost())
            iqn ="test"
            #targetName = "%s:%d:%s" % (iqn, time.time() * 1000, lvName)
            targetName = "%s:%d:%s" % (iqn, 123456, suffix)
            targetInfo = TargetInfo()
            targetInfo.targetName = targetName
            #targetInfo.targetPort = VSConfig.getIscsiPort()
            targetInfo.chapUser = 'nbs'
            #targetInfo.chapPass = getRandomPass()
            targetInfo.chapPass = 'netease'
            # "lio_node --addlun %s 1 0 iscsi00 iblock_0/%s_%s" %(targetName, VSConfig.getVgName(), lvName)
            actionLioAddLun(rollback, (targetName,tpgt,lun, 'test', lvName))
            #--addnp=TARGET_IQN TPGT IP:PORT
            osCmd = "lio_node --addnp %s %d %s:%d" % (targetName,tpgt, "0.0.0.0",3260)
            runExec(osCmd)
            # --enableauth=TARGET_IQN TPGT
            osCmd = "lio_node --enableauth %s %d" % (targetName,tpgt)
            runExec(osCmd)
            #lio_node --addlunacl <TargetIQN> <TPG#> <InitiatorIQN> <LUN#> <MappedLUN#>
            osCmd = "lio_node --addlunacl %s %d %s %d 0" % (targetName,tpgt ,initiatorName,lun)
            runExec(osCmd)
            #lio_node --setchapauth <TargetIQN> <TPG#><InitiatorIQN> <LoginName> <Password>
            osCmd = "lio_node --setchapauth %s %d %s %s %s" % (targetName, tpgt,initiatorName, targetInfo.chapUser, targetInfo.chapPass)
            runExec(osCmd)
            #    --settpgattr=TARGET_IQN TPGT <ATTRIB> <VALUE>
            osCmd = "lio_node --settpgattr=%s %d cache_dynamic_acls 0" % (targetName,tpgt)
            runExec(osCmd)
            #     --enabletpg=TARGET_IQN TPGT
            osCmd = "lio_node --enabletpg %s %d" % (targetName,tpgt)
            runExec(osCmd)
            print "sendTarget success"
            VSLogger.info("sendTarget success")
        except Exception, e:
            errMsg = traceback.format_exc()
            rollback.rollback()
            VSLogger.error(errMsg)
            raise VSException(-1, getExceptionErrorMessage(e))
        return targetInfo

    def detachLV(self, lvName):
        '''服务接口，卸载逻辑卷
        
        @param lvName 逻辑卷名称
        '''

        VSLogger.debug("Detach LV(%s) begin..." % (lvName))
        try:
            self.__purgeAttachLV(lvName)
        except Exception, e:
            errMsg = traceback.format_exc()
            VSLogger.error(errMsg)
            raise VSException(-1, getExceptionErrorMessage(e))
        VSLogger.info("Successfully detach LV %s." % (lvName))


    def cleanTarget(self, lvName, targetName,tpgt):
        # 先后顺序很重要，
        self.purgeIqn(targetName,tpgt)
        VSLogger.info("purgeIqn success")
        print "purgeIqn success"
        self.purgeTcm(lvName)
        VSLogger.debug("purgeTcm success")
        print "purgeTcm success"
        self.purgeIscsi(targetName)
        VSLogger.debug("purgeIscsi success")
        print "purgeIscsi success"
def startTarget(lvName,tpgt,lun,suffix):
    initiatorName = "iqn.1993-08.org.debian:01:5c487996fda6"
    iqn ="test"
    targetName = "%s:%d:%s" % (iqn, 123456, suffix)
    handler = VSServiceHandler()
    try:
        handler.sendTarget(lvName,tpgt,lun ,initiatorName,suffix)
        print "sendTarget success"
        VSLogger.debug("sendTarget success")
        #time.sleep(1)
        #handler.cleanTarget(lvName,targetName)
    except Exception, e:
        handler.cleanTarget(lvName,targetName,tpgt)
        handler.sendTarget(lvName,tpgt,lun, initiatorName,suffix)
        errMsg = traceback.format_exc()
        VSLogger.critical(errMsg)
def purgeTarget(lvName,tpgt,suffix):
    iqn ="test"
    targetName = "%s:%d:%s" % (iqn, 123456, suffix)
    handler = VSServiceHandler()
    try:
        handler.cleanTarget(lvName,targetName,tpgt)
        print "purgeTarget success"
        VSLogger.debug("purgeTarget success")
    except Exception, e:
        errMsg = traceback.format_exc()
        VSLogger.critical(errMsg)

debug=True
#debug=False
#handler.purgeIqn(targetName)
if __name__ == "__main__":
        VSConfig.loadConfig()
        VSLogger.initLogger()

        if debug:
            pdb.set_trace()
        for arg in sys.argv:
            print arg
        if cmp(sys.argv[1],'send')==0:
            startTarget(sys.argv[2],int(sys.argv[3]),int(sys.argv[4]),sys.argv[5])
        elif cmp(sys.argv[1],'purge')==0:
            purgeTarget(sys.argv[2],int(sys.argv[3]),sys.argv[4])

#        while True:
#            try:
#                handler.sendTarget("loop1", initiatorName)
#                print "sendTarget success"
#                VSLogger.debug("sendTarget success")
#                #time.sleep(1)
#                handler.cleanTarget("loop1",targetName)
#            except Exception, e:
#                handler.cleanTarget("loop1",targetName)
#                errMsg = traceback.format_exc()
#                VSLogger.critical(errMsg)

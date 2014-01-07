# -*- coding:UTF-8


import sys
import time
import os
import traceback
import threading
from VSExec import *
from VSLib  import *
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

def actionTcmCreate(rollback, device):
    '''执行tcm_node --block iblock_0/<bs_name> <block_dev>
    
    @param rollback 回滚类的一个实例
    @param param 存储了创建lio中tcm的多个参数的一个列表
    '''

    osCmd = "tcm_node --block iblock_0/%s /dev/%s" % (device)
    runExec(osCmd)
    rollback.actions.append((rollbackTcmCreate, device))

def rollbackLioAddLun(param):
    '''lio中增加lun的回滚函数
    @param param 存储了lio中增加lun的多个参数的一个列表
    '''

    osCmd = "lio_node --deliqn=%s" % param[0]
    try:
        runExec(osCmd)
    except Exception, e:
        VSLogger.error("rollback failed: run %s failed : %s " % (osCmd, repr(e)))

def actionLioAddLun(rollback, param):
    '''lio中增加lun
    
    @param rollback 回滚类的一个实例
    @param param 存储了lio中增加lun的多个参数的一个列表
    '''

    osCmd = "lio_node --addlun %s 1 0 iscsi00 iblock_0/%s" % (param[0], param[1])
    runExec(osCmd)
    rollback.actions.append((rollbackLioAddLun, param))


class VSServiceHandler:
    '''Volume Server的thrift服务接口的处理类
    '''

    def __init__(self):


    # 清理target中iscsi的配置
    def __purgeIscsi(self, targetName):
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

    # 清理target中tcm的配置
    def __purgeTcm(self, lvName):
        '''清理LIO中tcm的配置
        
        @param lvName 逻辑卷名称
        '''

        lioCfgDir = "/sys/kernel/config/target/core/iblock_0/%s" % (lvName)
        if os.path.exists(lioCfgDir):
            try:
                osCmd = "tcm_node --freedev iblock_0/%s" % (lvName)
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


    #InitiatorName=iqn.1993-08.org.debian:01:5c487996fda5
    def sendTarget(self, lvName, initiatorName):
        '''服务接口，输出target
        
        @param lvName 逻辑卷名称
        @param initiatorName 允许访问此逻辑卷的iscsi initor的名称
        @return 返回一个TargetInfo的结构体
        '''

        VSLogger.info("Call interface sendTarget(%s, %s)..." % (lvName, initiatorName))

        try:
            rollback = VSActionRollback()
            # 如果这个LV已经被挂上，则先清理掉
            #self.__purgeAttachLV(lvName)


            # "tcm_node --block iblock_0/%s_%s /dev/%s/%s" %(VSConfig.getVgName(), lvName, VSConfig.getVgName(), lvName)
            actionTcmCreate(rollback, lvName)

            #iqn = dnsName2IQN(VSConfig.getHost())
            iqn = "iqn.1993-08.org.debian:01:5c487996fda5"
            targetName = "%s:%d:%s" % (iqn, time.time() * 1000, lvName)
            # "lio_node --addlun %s 1 0 iscsi00 iblock_0/%s_%s" %(targetName, VSConfig.getVgName(), lvName)
            actionLioAddLun(rollback, (targetName, lvName))
    
            osCmd = "lio_node --enabletpg %s 1" % (targetName) 
            runExec(osCmd)

            osCmd = "lio_node --demomode %s 1" % (targetName)
            runExec(osCmd)
            osCmd = "lio_node --disableauth %s 1" % (targetName)
            runExec(osCmd)
            osCmd = "lio_node --settpgattr=%s  1 demo_mode_write_protect 0" % (targetName)
            runExec(osCmd)

        except Exception, e:
            errMsg = traceback.format_exc()
            rollback.rollback()
            VSLogger.error(errMsg)
            raise VSException(-1, getExceptionErrorMessage(e))

        VSLogger.info("Call sendtarget(%s, %s) is successful, return target name is %s ." % (lvName, initiatorName, targetName))
        VSLogger.debug("Call interface attachLV(%s, %s) is successful, return detail: %s ." % (lvName, initiatorName, repr(targetName)))

        return targetName

if __name__ == "__main__":
        InitiatorName=iqn.1993-08.org.debian:01:5c487996fda5
        try:
            handler = HostAgentServiceHandler()
            handler.sendTarget("loop0", initiatorName):

        except Exception, e:
            errMsg = traceback.format_exc()
            HostAgentLogger.critical(errMsg)
            sys.exit(-1)

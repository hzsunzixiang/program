# -*- coding:UTF-8


import sys
import time
import os
import traceback
import threading
import pdb

from VSExec import *
from VSLib  import *

# from VSConfig import VSConfig
# from VSLogger import VSLogger
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

def actionLioAddLun(rollback, param):
    '''lio中增加lun
    
    @param rollback 回滚类的一个实例
    @param param 存储了lio中增加lun的多个参数的一个列表
    '''

    osCmd = "lio_node --addlun %s 1 0 iscsi00 iblock_0/%s_%s" % (param[0], param[1], param[2])
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


    def sendTarget(self, lvName, initiatorName):
        '''服务接口，挂载逻辑卷
        
        @param lvName 输出target 
        @param initiatorName 允许访问此逻辑卷的iscsi initor的名称
        @return 返回一个TargetInfo的结构体
        '''

        VSLogger.info("Call interface attachLV(%s, %s)..." % (lvName, initiatorName))

        try:
            rollback = VSActionRollback()
            # 如果这个LV已经被挂上，则先清理掉
            # self.__purgeAttachLV(lvName)
            # "tcm_node --block iblock_0/%s_%s /dev/%s/%s" %(VSConfig.getVgName(), lvName, VSConfig.getVgName(), lvName)
            #actionTcmCreate(rollback, (VSConfig.getVgName(), lvName))
            actionTcmCreate(rollback, ('test', lvName))
            #iqn = dnsName2IQN(VSConfig.getHost())
            iqn ="test"
            #targetName = "%s:%d:%s" % (iqn, time.time() * 1000, lvName)
            targetName = "%s:%d:%s" % (iqn, 123456, lvName)
            targetInfo = TargetInfo()
            targetInfo.targetName = targetName
            #targetInfo.targetPort = VSConfig.getIscsiPort()
            targetInfo.chapUser = 'nbs'
            #targetInfo.chapPass = getRandomPass()
            targetInfo.chapPass = 'netease'
            # "lio_node --addlun %s 1 0 iscsi00 iblock_0/%s_%s" %(targetName, VSConfig.getVgName(), lvName)
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


    def cleanTarget(self, lvName, targetName):
        # 先后顺序很重要，
        self.purgeIqn(targetName)
        VSLogger.info("purgeIqn success")
        print "purgeIqn success"
        self.purgeTcm(lvName)
        VSLogger.debug("purgeTcm success")
        print "purgeTcm success"
        self.purgeIscsi(targetName)
        VSLogger.debug("purgeIscsi success")
        print "purgeIscsi success"
def startTarget(lvName):
    initiatorName = "iqn.1993-08.org.debian:01:5c487996fda6"
    iqn ="test"
    targetName = "%s:%d:%s" % (iqn, 123456, lvName)
    handler = VSServiceHandler()
    try:
        handler.sendTarget(lvName, initiatorName)
        print "sendTarget success"
        VSLogger.debug("sendTarget success")
        #time.sleep(1)
        #handler.cleanTarget(lvName,targetName)
    except Exception, e:
        handler.cleanTarget(lvName,targetName)
        handler.sendTarget(lvName, initiatorName)
        errMsg = traceback.format_exc()
        VSLogger.critical(errMsg)
def purgeTarget(lvName):
    iqn ="test"
    targetName = "%s:%d:%s" % (iqn, 123456, lvName)
    handler = VSServiceHandler()
    try:
        handler.cleanTarget(lvName,targetName)
        print "purgeTarget success"
        VSLogger.debug("purgeTarget success")
    except Exception, e:
        errMsg = traceback.format_exc()
        VSLogger.critical(errMsg)

#debug=True
debug=False
#handler.purgeIqn(targetName)
if __name__ == "__main__":
        if debug:
            pdb.set_trace()
        for arg in sys.argv:
            print arg
        if cmp(sys.argv[1],'send')==0:
            startTarget("loop1")
        elif cmp(sys.argv[1],'purge')==0:
            purgeTarget("loop1")

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

class VSServiceManager(threading.Thread):
    '''服务接口管理类，运行实际的thrift服务    
    '''

    def __init__(self, statusData):
        '''类的初使用化函数
        
        @param statusData，Volume Server的状态数据类，可以把一些状态数据放到这个变量中
        '''

        threading.Thread.__init__(self)
        self.port = None
        self.transport = None
        self.protocol = None
        self.rpcClient = None
        self.done = False
        self.statusData = statusData

    def run(self):
        '''线程运行函数
        '''
        try:
            handler = VSServiceHandler()
            processor = VSService.Processor(handler)
            # for thrift8.0.0
            # transport = TSocket.TServerSocket(VSConfig.getIpAddr(), VSConfig.getIpcPort())
            transport = TSocket.TServerSocket(port=VSConfig.getIpcPort())
            tfactory = TTransport.TBufferedTransportFactory()
            pfactory = TBinaryProtocol.TBinaryProtocolFactory()
            #server = TServer.TThreadedServer(processor, transport, tfactory, pfactory, daemon=True)
            server = TServer.TThreadPoolServer(processor, transport, tfactory, pfactory, daemon=True)

        except Exception:
            VSLogger.critical(traceback.format_exc())
            sys.exit(1)

        while not self.done:
            try:
                server.serve()
            except Exception:
                VSLogger.error(traceback.format_exc())
                time.sleep(1)







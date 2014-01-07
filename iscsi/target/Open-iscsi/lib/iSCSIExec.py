

import subprocess 
from iSCSILogger import iSCSILogger

def runExec(cmd):
    iSCSILogger.debug("run %s " % cmd)
    outMsg = ''
    try:
        p = subprocess.Popen(cmd, shell=True, close_fds=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)  
        outMsg = p.stdout.read()
        errMsg = p.stderr.read()
        errCode = p.wait()
    except Exception, e:
        raise e

    if errCode:
        raise Exception("Run cmd %s failed: \n errcode = %d, \n %s" % (cmd, errCode, errMsg))
    return outMsg


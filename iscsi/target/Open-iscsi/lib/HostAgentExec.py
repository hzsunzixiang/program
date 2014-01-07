
import subprocess  

from HostAgentLogger import HostAgentLogger

def runExec(cmd):
    HostAgentLogger.debug("run %s " % cmd)
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


def sendToExec(cmd, data):
    HostAgentLogger.debug("run %s, stdin data: %s " % (cmd, data ))
    outMsg = ''
    
    try:
        p = subprocess.Popen(cmd, shell=True,  close_fds=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        p.stdin.write(data+"\n")
        p.stdin.close()
        outMsg = p.stdout.read()
        errMsg = p.stderr.read()
        errCode = p.wait()
    except Exception, e:
        raise e

    if errCode:
            raise Exception("Run cmd %s failed, input data: %s\nerrcode= %d,\n %s" % (cmd, data, errCode, errMsg))
    return outMsg

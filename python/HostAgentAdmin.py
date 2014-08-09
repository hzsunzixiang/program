#!/usr/bin/env python
# -*- coding:UTF-8

'''
Created on 2012-07-20

@author: tangcheng

手工调用HostAgent上服务的程序

'''

import sys
import re
from optparse import OptionParser
from optparse import OptionValueError
import json


from hostagentservice import HostAgentService
from hostagentservice.ttypes import *

from thrift import Thrift
from thrift.transport import TSocket
from thrift.transport import TTransport
from thrift.protocol import TBinaryProtocol

from HostAgentLib  import diskSizeToByters
from HostAgentConfig import HostAgentConfig

def connectServer(host, port):
    transport = TSocket.TSocket(host, port)
    transport = TTransport.TBufferedTransport(transport)
    protocol = TBinaryProtocol.TBinaryProtocol(transport)
    client = HostAgentService.Client(protocol)
    transport.open()
    return (client, transport)

def attachVolume(args, options):
    ArgsInfo = str(args)
    cells = ArgsInfo.split(',')
    nums = len(cells)
    if nums < 9 or ((nums - 3) % 6) != 0:
        raise Exception("Invalid args!")

    host = options.host
    port = options.port

    projectId = cells[0]
    volumeId = cells[1]
    vmInstanceId = cells[2]
    chunkNums = (nums - 3) / 6
    pos = 3
    chunkList = []
    for i in range(0, chunkNums):
        diskChunk = DiskChunk()
        diskChunk.targetName = cells[pos]
        pos = pos + 1
        diskChunk.ip = cells[pos]
        pos = pos + 1
        diskChunk.port = int(cells[pos])
        pos = pos + 1
        diskChunk.size = diskSizeToByters(cells[pos])
        pos = pos + 1
        diskChunk.chapUser = cells[pos]
        pos = pos + 1
        diskChunk.chapPass = cells[pos]
        pos = pos + 1
        chunkList.append(diskChunk)

    (client, transport) = connectServer(host, port)
    DevicePath = client.attachVolume(projectId, volumeId, vmInstanceId, chunkList)
    if options.json:
        dt = {'action' :'attachVolume',
              'device_path' : DevicePath
              }
        print json.dumps(dt)
    else:
        print "Attach Volume : %s ." % (ArgsInfo)
        print "DevicePath : %s" % (DevicePath)

    transport.close()

def detachVolume(args, options):
    ArgsInfo = str(args)
    cells = ArgsInfo.split(',')
    nums = len(cells)
    if nums != 4:
        raise Exception("Invalid args!")

    host = options.host
    port = int(options.port)

    projectId = cells[0]
    volumeId = cells[1]
    deviceName = cells[2]
    vmInstanceId = cells[3]

    (client, transport) = connectServer(host, port)
    client.detachVolume(projectId, volumeId, deviceName, vmInstanceId)
    if options.json:
        dt = {'action' :'detachVolume',
              'volume_id' : volumeId
              }
        print json.dumps(dt)
    else:
        print "Detach Volume : %s ." % (ArgsInfo)
    transport.close()

def purgeVolume(args, options):
    ArgsInfo = str(args)
    cells = ArgsInfo.split(',')
    nums = len(cells)
    if nums != 1:
        raise Exception("Invalid args!")

    volumeId = cells[0]

    host = options.host
    port = int(options.port)

    (client, transport) = connectServer(host, port)
    client.purgeVolume('', volumeId)
    if options.json:
        dt = {'action' :'purgeVolume',
              'volume_id' : volumeId
              }
        print json.dumps(dt)
    else:
        print "Purge Volume : %s ." % (volumeId)
    transport.close()

def extendVolume(args, options):
    ArgsInfo = str(args)
    cells = ArgsInfo.split(',')
    nums = len(cells)
    if nums != 10:
        raise Exception("Invalid args!")

    host = options.host
    port = options.port

    projectId = cells[0]
    volumeId = cells[1]
    vmInstanceId = cells[2]
    chunkNums = (nums - 3) / 6
    pos = 3
    diskChunk = DiskChunk()
    diskChunk.targetName = cells[pos]
    pos = pos + 1
    diskChunk.ip = cells[pos]
    pos = pos + 1
    diskChunk.port = int(cells[pos])
    pos = pos + 1
    diskChunk.size = diskSizeToByters(cells[pos])
    pos = pos + 1
    diskChunk.chapUser = cells[pos]
    pos = pos + 1
    diskChunk.chapPass = cells[pos]
    pos = pos + 1
    deviceName = cells[pos]

    (client, transport) = connectServer(host, port)

    newSize = client.extendVolume(projectId, volumeId, vmInstanceId, diskChunk, deviceName)
    print "extend Volume : %s ." % (ArgsInfo)
    print "New Size : %d" % (newSize)
    transport.close()

def extendLV(args, options):
    ArgsInfo = str(args)
    cells = ArgsInfo.split(',')
    nums = len(cells)
    if nums != 6:
        raise Exception("Invalid args!")

    host = options.host
    port = int(options.port)

    projectId = cells[0]
    volumeId = cells[1]

    lvName = cells[2]
    lvNewSize = diskSizeToByters(cells[3])
    vmInstanceId = cells[4]
    deviceName = cells[5]

    (client, transport) = connectServer(host, port)
    newSize = client.extendLV(projectId, volumeId, lvName, lvNewSize, vmInstanceId, deviceName)
    if options.json:
        dt = {'action' :'extendLV',
              'new_size' : newSize
              }
        print json.dumps(dt)
    else:
        print "extend LV : %s, New Size: %d" % (ArgsInfo, newSize)
    transport.close()

def setActionOption(option, opt_str, value, parser):
    if hasattr(parser.values, "action"):
        raise OptionValueError("Option '%s' and Option '%s' can not together" % (opt_str, parser.values.action))

    actionDict = {"--attachvolume": attachVolume,
                  "--detachvolume": detachVolume,
                  "--extendvolume": extendVolume,
                  "--extendlv":     extendLV,
                  "--purgevolume" : purgeVolume,
                  "--extendvolume": extendVolume,
                  "--extendlv"    : extendLV
                  }
    setattr(parser.values, "action", actionDict[opt_str])
    setattr(parser.values, "action_args", value)

def main():

    import pdb
    pdb.set_trace()
    HostAgentConfig.loadConfig()
    ipAddr = HostAgentConfig.getIpAddr()
    ipPort = HostAgentConfig.getIpcPort()
    
    parser = OptionParser()
    parser.add_option("--host", action="store", dest="host", default=ipAddr, help="Specifies the host name")
    parser.add_option("--port", action="store", dest="port", default=ipPort, type="string", help="Specifies the port")
    parser.add_option("--json", action="store_true", dest="json", default=False, help="Json format output")

    parser.add_option("--attachvolume", action="callback", callback=setActionOption, nargs=1,
        type="string", dest="<projectId>,<volumeId>,<vm_uuid>,<target>,<ip>,<port>,<size>,<chapUser>,<chapPass>,[,<target>,<ip>,<port>,<size>,...]...",
        help="Attach EBS Disk")
    parser.add_option("--detachvolume", action="callback", callback=setActionOption, nargs=1,
        type="string", dest="<projectId>,<volumeId>,<device_name>,<vm_uuid>", help="Detach EBS Disk")
    parser.add_option("--purgevolume", action="callback", callback=setActionOption, nargs=1,
        type="string", dest="<volumeId>", help="Purge EBS Disk")
    parser.add_option("--extendvolume", action="callback", callback=setActionOption, nargs=1,
        type="string", dest="<projectId>,<volumeId>,<vm_uuid>,<target>,<ip>,<port>,<size>,<chapUser>,<chapPass>,<device_name>",
        help="Extend EBS Disk by extend add new LV")
    parser.add_option("--extendlv", action="callback", callback=setActionOption, nargs=1,
        type="string", dest="<projectId>,<volumeId>,<lv_name>,<lvNewSize>,<vm_uuid>,<device_name>",
        help="Extend EBS Disk by extend last LV")

    (options, args) = parser.parse_args()
    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(0)
    elif not re.search('--', sys.argv[1]):
        print "Unknown option: " + sys.argv[1]

    if not hasattr(parser.values, "action"):
        parser.print_help()

    try:
        parser.values.action(parser.values.action_args, options)
    except Exception, e:
        errMsg = str(e).replace('\\n', '\n')
        print >> sys.stderr, "%s" % errMsg
        sys.exit(-1)
    sys.exit(0)


if __name__ == "__main__":
    main()


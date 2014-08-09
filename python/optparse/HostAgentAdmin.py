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


def attachVolume(args, options):
    pass

def detachVolume(args, options):
    pass
def purgeVolume(args, options):
    ArgsInfo = str(args)
    cells = ArgsInfo.split(',')
    nums = len(cells)
    if nums != 1:
        raise Exception("Invalid args!")
    volumeId = cells[0]
    print "over"
def extendVolume(args, options):
    pass

def extendLV(args, options):
    pass

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
    # action在这里是可以用其他词替换的
    setattr(parser.values, "action", actionDict[opt_str])
    setattr(parser.values, "action_args", value)

def main():

    import pdb
    #pdb.set_trace()
    ipAddr = "114.113.199.19"
    ipPort = "8989"
    
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


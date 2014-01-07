#!/usr/bin/env python
# -*- coding:UTF-8

import sys
import binascii
import os
from HostAgentExec import *

def dnsName2IQN(dnsName):
    '''通过域名，获得iscsi中的iqn的名称
    
    @param dnsName 域名
    '''
    
    dnscell = dnsName.split('.')
    iqn = 'iqn.2012-01.'+'.'.join(dnscell[::-1])
    return iqn

def diskSizeToByters(diskSize):
    '''把带K、M、G、T单位的大小値转成字节数
    
    @param diskSize 带K、M、G、T单位的大小値
    @return 返回字节数
    '''
    
    if len(diskSize)<=0:
        return 0

    unitChar = diskSize[-1].lower()
    if unitChar.isdigit():
        numSize = int(diskSize)
    else:
        if unitChar == 't':
            unitValue = 1024*1024*1024*1024        
        elif unitChar == 'g':
            unitValue = 1024*1024*1024
        elif unitChar == 'm':
            unitValue = 1024*1024
        elif unitChar == 'k':
            unitValue = 1024
        else:
            unitValue = 1
        numSize = int(float(diskSize[0:-1])*unitValue)
    return numSize

def makeDmName(dmNamePrefix, projectId, volumeId):
    '''通过DM设置前缀＋projectId＋volumeId组合出dm的设备名
    
    EBS中生成的dm设备名，格式为<dmNamePrefix>_<projectId>_<volumeId>_<crc32>'''

    crc = binascii.crc32('%s_%s_%s' % (dmNamePrefix, projectId, volumeId))
    if crc< 0:
        crc = 2**32 + crc
    return "%s_%s_%s_%d" % (dmNamePrefix, projectId, volumeId, crc)

def isEBSDmName(dmNamePrefix, dmName):
    '''判断是否是本HostAgent在dmsetup中的生成的设备
    
    EBS中生成的设备名，格式为<dmNamePrefix>_<projectId>_<volumeid>_<crc32>
    
    @param dmNamePrefix Device Mapper设备前缀名
    @param dmName Device Mapper设备前缀名
    @return 是Device Mapper设备名则返回1，否则返回0
    '''
    
    cells = dmName.split('_')
    if len(cells) != 4:
        return 0
    
    if cells[0] != dmNamePrefix:
        return 0
    
    crc = binascii.crc32(cells[0]+'_'+cells[1]+'_'+cells[2])
    if crc< 0:
        crc = 2**32 + crc
    nbsDmName = "%s_%s_%s_%d" %(dmNamePrefix, cells[1], cells[2], crc)
    
    if dmName == nbsDmName:
        return 1
    return 0

def getVolumeIdFromDmName(dmNamePrefix, dmName):
    '''从DM设备名中取得VolumeId
    
    EBS中生成的设备名，格式为<dmNamePrefix>_<projectId>_<volumeid>_<crc32>
    
    @param dmName Device Mapper设备前缀名
    @return volumeId，如果不是DM设备名，则返回None
    '''
    
    if not isEBSDmName(dmNamePrefix, dmName):
        return None
    
    cells = dmName.split('_')    
    return cells[2]


def getInitiatorName():
    '''从/etc/iscsi/initiatorname.iscsi读取本机的initiator名称
    @return initiator名称
    '''
    
    fh = open('/etc/iscsi/initiatorname.iscsi', 'r')
    initiatorName = ''
    for line in  fh.readlines():
        line = line.strip()
        if len(line) <= 0:
            continue
        if line[0] =='#':
            continue
        pos = line.find('=',0)
        if pos == -1:
            continue
        if line[0:pos] != 'InitiatorName':
            continue
        initiatorName = line[pos+1:]
    fh.close()
    return initiatorName


def getDMInfo( dmName ):
    '''执行dmsetup info <dmName> 获得device mapper的信息
    
       信息中有device mapper设备是否被suspend的状态 
    '''
    
    outMsg=runExec('/sbin/dmsetup info %s' % dmName)
    
    dmInfoDict = {}
    msgLines = outMsg.splitlines()
    for line in msgLines: 
        line=line.strip()
        if len(line)<=0:
            continue
        cells = line.split(':')
        if len(cells)<2:
            continue
        dmInfoDict[cells[0].strip()] = cells[1].strip()
    return dmInfoDict

def getBlockDevSize(devPath):
    '''获得块设备的大小
    
    传入块设备的路径，返回字节数'''
    
    fd= os.open(devPath, os.O_RDONLY)
    try:
        return os.lseek(fd, 0, os.SEEK_END)
    finally:
        os.close(fd)
        

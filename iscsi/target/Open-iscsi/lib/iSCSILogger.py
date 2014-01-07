# -*- coding: utf8 -*-
'''

'''

import logging.handlers
import os
import sys

class iSCSILogger:
    logger = None
    modulePath = os.path.split(os.path.realpath(sys.argv[0]))[0]
    logPath = os.path.abspath("%s/../log" % modulePath)
    if not os.path.exists(logPath):
        os.mkdir(logPath)
    logFileName = logPath + "/iSCSI.log"

    @staticmethod
    def initLogger(level=logging.DEBUG, onlyLogFile=False):
        iSCSILogger.logger = logging.getLogger()

        formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')
        logFileHdl = logging.handlers.RotatingFileHandler(iSCSILogger.logFileName, maxBytes=10 * 1024 * 1024, backupCount=10)

        logFileHdl.setFormatter(formatter)
        if not onlyLogFile:
            stdoutHdl = logging.StreamHandler()
            stdoutHdl.setFormatter(formatter)
            iSCSILogger.logger.addHandler(stdoutHdl)
        iSCSILogger.logger.addHandler(logFileHdl)
        iSCSILogger.logger.setLevel(level)

    @staticmethod
    def setLevel(level):
        if iSCSILogger.logger:
            iSCSILogger.logger.setLevel(level)

    @staticmethod
    def info(message):
        if iSCSILogger.logger:
            iSCSILogger.logger.info(message.replace('\n', '\n  '))

    @staticmethod
    def debug(message):
        if iSCSILogger.logger:
            iSCSILogger.logger.debug(message.replace('\n', '\n  '))

    @staticmethod
    def warn(message):
        if iSCSILogger.logger:
            iSCSILogger.logger.warn(message.replace('\n', '\n  '))

    @staticmethod
    def critical(message):
        if iSCSILogger.logger:
            iSCSILogger.logger.critical(message.replace('\n', '\n  '))


    @staticmethod
    def error(message):
        if iSCSILogger.logger:
            iSCSILogger.logger.error(message.replace('\n', '\n  '))

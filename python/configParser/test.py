# -*- coding:UTF-8
'''
@author
'''


import os
import sys
import ConfigParser
import pdb
import string

_ConfigDefault = {
    "database.dbms":            "mysql",
    "database.name":            "",
    "database.user":            "root",
    "database.password":        "",
    "database.host":            "127.0.0.1"
    }

def LoadConfig(file, config={}):
    """
    returns a dictionary with keys of the form
    <section>.<option> and the corresponding values
    """
    #返回一个字典,格式如下: key:     <section>.option>
    #                   value :  对应的值 
       


    config = config.copy(  )
    cp = ConfigParser.ConfigParser(  )
    cp.read(file)
    for sec in cp.sections(  ):
        name = string.lower(sec)
        for opt in cp.options(sec):
            config[name + "." + string.lower(opt)] = string.strip(
                cp.get(sec, opt))
    return config

if __name__=="__main__":
    pdb.set_trace()
    print LoadConfig("some.ini", _ConfigDefault)






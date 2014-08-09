#!/usr/bin/env python

from optparse import OptionParser

def main():
    parser = OptionParser(usage="usage: %prog [options] filename",
                          version="%prog 1.0")
    parser.add_option("-x", "--xhtml",
                      action="store_true",
                      dest="xhtml_flag",
                      default=False,
                      help="create a XHTML template instead of HTML")
    parser.add_option("-c", "--cssfile",
                      action="store", # optional because action defaults to "store"
                      dest="cssfile__",
                      metavar="FILE",
                      default="style.css",
                      help="CSS file to link",)
#parser.set_defaults(cssfile__="foo.txt",xhtml_flag=True)  
    (options, args) = parser.parse_args()

    if len(args) != 1:
        parser.error("wrong number of arguments")

    print options
    print options.cssfile__
    print options.xhtml_flag
    print "============================"
    print args

if __name__ == '__main__':
    main()

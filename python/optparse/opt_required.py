#!/usr/bin/env python

from optparse import OptionParser
import sys

parser = OptionParser(usage='usage: %prog [options] arguments')
parser.add_option('-f', '--file',dest='filename',help='foo help')

(options, args) = parser.parse_args()
if len(sys.argv) == 1:
    parser.print_help()
    parser.error('Filename not given')
    sys.exit(0)
if not options.filename:   # if filename is not given
    parser.error('Filename not given')

if __name__ == '__main__':
    main()

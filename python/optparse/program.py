#!/usr/bin/env python

from optparse import OptionParser

def main():
    parser = OptionParser(usage="usage: %prog [options] filename",
                          version="%prog 1.0")
    print "%prog"

if __name__ == '__main__':
    main()

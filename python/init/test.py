# -*- coding:UTF-8
'''
@author
'''
class Complex:
    #def __init__(self, realpart, imagpart):
    def __init__(self):
        self.r = 2 
        self.i = 3 

if __name__ == '__main__':
    x = Complex()
    #x = Complex(3.0, -4.5)
    x.r= 6
    x.i=8
    print x.r, x.i

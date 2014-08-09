from time import time


def time_this( function_callable, return_value=False ):
    start_time = time()
    function_callable()
    end_time = time()
    
    if (return_value):
        return end_time - start_time
    else:
        print "time: ", end_time - start_time
    
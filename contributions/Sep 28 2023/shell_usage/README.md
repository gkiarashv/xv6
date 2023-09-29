# Date Examples
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/datecmd.png)




# Time Examples
In the following, there are examples of how to work with the `time` keyword of the xv6 sehll executed once in user mode and once in kernel mode. Considering two example files as follows:


## File1
![file1](https://github.com/gkiarashv/xv6/blob/main/images/file1.png)


## File2
![file2](https://github.com/gkiarashv/xv6/blob/main/images/file2.png)



# User mode


## time ls

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/timels.png)

## time head -n 3 (Delaying purposefully)

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/timeheadn3.png)

## time cat file1 | time head -n 5

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/timecathead.png)


## time uniq -c (Delaying purposefully)

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/timeuniquserc.png)


## time uniq file1 file2

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/timeuniqfile1file2.png)





# Kernel mode

## time head -n 3 (Delaying purposefully)

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/timeheadn3kernel.png)

## time cat file1 | time head -n 7

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/timecatheadkernel.png)

## time uniq -c file1 file2
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/timeuniqcfile1file2kernel.png)







# ps command

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/ps.png)

## ps -pid 1
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/pspid1.png)


## ps -pid 2
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/pspid2.png)

## ps -ppid 2
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/psppid2.png)

## ps -stat sleeping
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/psstatsleeping.png)

## ps -stat running
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/psstatrunning.png)

## ps -name s
Containing `s` in the name.
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/psnames.png)


## ps -name ni
Containing `ni` in the name.
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/psnameni.png)


## ps -pid 2 -ppid 1
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/pspidppid.png)








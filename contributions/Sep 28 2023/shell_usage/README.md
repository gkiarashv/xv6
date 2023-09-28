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

## time head -n 3 (Delaying purposfully)

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/timeheadn3.png)

## time cat file1 | time head -n 5

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/timecathead.png)



# Kernel mode

## time head -n 3 (Delaying purposfully)

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/timeheadn3kernel.png)

## time cat file1 | time head -n 7

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/timecatheadkernel.png)









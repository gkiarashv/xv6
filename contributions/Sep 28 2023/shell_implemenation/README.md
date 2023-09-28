
The modifications in the `sh.c` have been made in two spots. First, the `runcmd()` function which runs the commands. In this function, we have only made change
to the `EXEC` case as any type of complex command is first broken into small `EXEC` type commands. The `EXEC` case has been shown in the following figure:

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/runcmd.png)


First it is checked if the simple command to be exectured starts with the keyword `time` or not. If not, the execution is as before. Otherwise, we need to calculate the timing 
information as well. For this, we have defined a function in `user/time.c` called as `get_time_perf()`. This function forks a process to execute the intended command and then calls the `times` system call to retrieve the timing information.

The implementation of `get_time_perf()` is as follows:

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/timeperf.png)



After getting the timing information, in the `runcmd()` function, we write the execution criteria including the command name and its time information to the the `.temp` file. Here, we utilized the `O_APPEND` mode to append to this file
whenever a command is being executed. After all parts of the command is executed, we print the timing summary. This has been done in `main()` of `sh.c` after the command is executed:


![cmd](https://github.com/gkiarashv/xv6/blob/main/images/printtimeinfo.png)




First, we check if the `.time` file exists and if yes, we call the `print_time_info()` to print the information stored in it. Then, we will remove the file from the disk.
The implementation of the `print_time_info()` is as follows:



![cmd](https://github.com/gkiarashv/xv6/blob/main/images/printtimeinfofunction.png)




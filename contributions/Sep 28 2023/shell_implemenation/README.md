# Date command

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/dateimp.png)




# Time keyword
Changes were implemented in two specific sections of `sh.c`. Firstly, adjustments were made in the `runcmd()` function, which is responsible for executing commands. These modifications were focused on the EXEC case because any type of command is initially broken down into smaller EXEC type commands. The  EXEC case is illustrated in the following diagram:


![cmd](https://github.com/gkiarashv/xv6/blob/main/images/runcmd.png)


First it is checked if the simple command to be exectured starts with the keyword `time` or not. If not, the execution is as before. Otherwise, we need to calculate the timing 
information as well. For this, we have defined a function in `user/time.c` called as `get_time_perf()`. This function forks a process to execute the intended command and then calls the `times` system call to retrieve the timing information.

Initially, the program verifies whether the simple command to be executed begins with the term `time` or not. If it doesn't, the execution proceeds as it did previously. However, if it does start with `time`, timing information needs to be computed. To achieve this, a function named `get_time_perf()` was created in `user/time.c`. This function creates a child process to run the specified command and utilizes the times system call to fetch the timing data.

The implementation of `get_time_perf()` is as follows:

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/timeperf.png)


Once the timing details are acquired, within the `runcmd()` function, we record the execution specifics, such as the command name and its timing data, into the `.temp` file. In this process, the `O_APPEND` mode is employed, ensuring that the information is appended to the file whenever a command is executed. Once all subcommands of the command have been executed, the timing summary is printed. This operation takes place in the `main()` function of `user/sh.c` after the command has been executed.



![cmd](https://github.com/gkiarashv/xv6/blob/main/images/printtimeinfo.png)


Initially, we verify the existence of the `.time` file. If it exists, we invoke the `print_time_info()` function to display the stored information. Subsequently, the file is deleted from the disk. The `print_time_info()` function is implemented as follows:

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/printtimeinfofunction.png)




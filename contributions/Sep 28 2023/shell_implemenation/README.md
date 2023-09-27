
The modifications in the `sh.c` have been made in two spots. First, the `runcmd()` function which runs the commands. In this function, we have only made change
to the `EXEC` case as any type of complex command is first broken into small `EXEC` type commands. The `EXEC` case has been shown in the following figure:

FIG



First it is checked if the simple command to be exectured starts with the keyword `time` or not. If not, the execution is as before. Otherwise, we need to calculate the timing 
information as well. For this, we have defined a function in `user/time.c` called as `get_time_perf()`. This function forks a process to execute the intended command and then calls the `times`
system call to retrieve the timing information.

The implementation of `get_time_perf()` is as follows:



FIG








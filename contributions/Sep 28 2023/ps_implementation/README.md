# ps command
The `ps` command has been written in the `user/ps.c` file. The `parse_cmd()` function parses the `ps` command to extract the potential options of `pid`, `ppid`, `stat`, and `name`.


![cmd](https://github.com/gkiarashv/xv6/blob/main/images/psusermain.png)


![cmd](https://github.com/gkiarashv/xv6/blob/main/images/psuserparse.png)


# ps system call
The `ps` system call has been written in the `kernel/sysproc.c` and `kernel/elibs/ps.c`:

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/sysps.png)

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/psimp1.png)
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/psimp2.png)
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/psimp3.png)
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/psimp4.png)


In this approach, we go through the list of processes. If an option has been specified and we don't find a process that meets this criteria, we skip it using the `continue` statement within the loop's if condition.

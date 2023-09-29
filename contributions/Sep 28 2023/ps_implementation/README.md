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


In this implementation, we iterate over the list of processes and if any option has been provided and we do not match a process that satisfy this condition, we skip it by `continue` in the if conidtion of the loop.

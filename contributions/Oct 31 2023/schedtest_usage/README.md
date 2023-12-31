# schedtest command

To test the `schedtest` command, we first test it against two new commands that can give an in-depth inside of execution.

## t1 and t2 commands
Two new commands of `t1` and `t2` have been written with the same simple codes:

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/t1.png)

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/t2.png)


## file1 and file2 files
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/file1.png)
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/file2.png)


## Number of CPUs
Moreover, we have changed the number of CPUs from 3 to 1 in the Makefile to showcase the correctness of the scheduling.


## Tick time
The timer interval of the kernel has been changed so the timing becomes reasonable:
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/intervaltimer.png)



# FCFS test
To test FCFS scheduling, first, compile the kernel using `make SCHED=FCFS`.

## schedtest -c t1 -c t2
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/schede1.png)

## schedtest -c t2 -c t1
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/schede2.png)


## schedtest -c head file1 -c head -k file2 (Kernel head with file2)
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/schede3.png)


## schedtest -c head -k file2 -c head file1 (Kernel head with file2)
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/schede4.png)


## schedtest -c uniq -i file1 -c uniq -k file2 (Kernel uniq with file2)
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/schede5.png)


## schedtest -c uniq -k file2 -c uniq file1 (Kernel uniq with file2)
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/sche6.png)








# PS test
To test Priority scheduling, first, compile the kernel using `make SCHED=PS`.

## schedtest -p 9 -c t1 -p 8 -c t2
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/schede7.png)

## schedtest -p 3 -c t1 -p 8 -c t2
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/schede8.png)

## schedtest -p 3 -c head file1 -p 2 -c head -k file2 (Kernel head with file2)
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/schede9.png)


## schedtest -p 2 -c head file1 -p 7 -c head -k file2 (Kernel head with file2)
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/schede10.png)

## schedtest -p 3 -c uniq -i file1 -p 2 -c uniq -k file2 (Kernel uniq with file2)
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/schede11.png)

## schedtest -p 2 -c uniq -i file1 -p 7 -c uniq -k file2 (Kernel uniq with file2)
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/schede12.png)




# schedtest command

To test the `schedtest` command, we first test it against two new commands that can give in-depth inside of execution.

## t1 and t2 commands
Two new commands of `t1` and `t2` have been written with the same simple codes:

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/t1.png)

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/t2.png)


## file1 and file2 files
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/file1.png)
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/file2.png)



Moreover, we have changed the number of CPUs from 3 to 1, to showcase the effects of the scheduling.


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
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/schede6.png)








# PS test
To test Priority scheduling, first, compile the kernel using `make SCHED=PS`.

## schedtest -p 9 -c t1 -p 8 -c t2
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/pst1.png)

## schedtest -p 3 -c t1 -p 8 -c t2
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/pst2.png)


## schedtest -p 3 -c t1 -p 8 -c t2 (delayed)
To make timing information more understandable, we have added a delay function to the for loops of `t1` and `t2`:
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/pst3.png)


## schedtest -p 3 -c head file1 -p 2 -c head -k file2 (Kernel head with file2)
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/schedhead3.png)


## schedtest -p 2 -c head file1 -p 7 -c head -k file2 (Kernel head with file2)
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/schedhead4.png)



## schedtest -p 3 -c uniq -i file1 -p 2 -c uniq -k file2 (Kernel uniq with file2)
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/scheduniq3.png)


## schedtest -p 2 -c uniq -i file1 -p 7 -c uniq -k file2 (Kernel uniq with file2)
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/scheduniq4.png)




# schedtest command

To test the `schedtest` command, we first test it against two new commands that can give in-depth inside of execution.

## t1 and t2 commands
Two new commands of `t1` and `t2` have been written with the same simple codes:

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/t1.png)

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/t2.png)


Moreover, we have changed the number of CPUs from 3 to 1, to showcase the effects of the scheduling.


# FCFS test
To test FCFS scheduling, first, compile the kernel using `make SCHED=FCFS`.

## schedtest -c t1 -c t2
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/fcfst1.png)

## schedtest -c t2 -c t1
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/fcfst2.png)

## schedtest -c t2 -c t1
To make timing information more understandable, we have added a delay function to the for loops of `t1` and `t2`:
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/delay2.png)


![cmd](https://github.com/gkiarashv/xv6/blob/main/images/fcfst3.png)






# PS test
To test Priority scheduling, first, compile the kernel using `make SCHED=PS`.

## schedtest -p 9 -c t1 -p 8 -c t2
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/pst1.png)

## schedtest -p 3 -c t1 -p 8 -c t2
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/pst2.png)







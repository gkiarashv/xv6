# Examples


In the following, there are examples of how to work with the head command in the xv6 environment executed once in user mode and once in kernel mode.
Considering two example files as follows:


## File 1
![file1](https://github.com/gkiarashv/xv6/blob/main/images/file1.png)

## File2
![file2](https://github.com/gkiarashv/xv6/blob/main/images/file2.png)

# User mode

## head
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/headuserex1.png)

## head -n 4
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/headuserex2.png)

## cat file1 | head
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/headuserex3.png)

## cat file1 | head -n 4
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/headuserex4.png)

## head file1 file2
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/headuserex5.png)

## head file1 file2 -n 3
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/headuserex6.png)



# Kernel mode

## head -n 4
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/headkernelex1.png)

## cat file1 | head -n 3
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/headkernelex2.png)

## head file1 file2
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/headkernelex3.png)

## head README file1 file2 -n 8
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/headkernelex4.png)

## head README file1
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/headkernelex5.png)

![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/headkernelex6.png)





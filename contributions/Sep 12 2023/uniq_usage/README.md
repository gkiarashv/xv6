# Examples

In the following, there are examples of how to work with the uniq command in the xv6 environment executed once in user mode and once in kernel mode.
Considering two example files as follows:


# File1
![file1](https://github.com/gkiarashv/xv6/blob/main/images/file1.png)

# File2
![file2](https://github.com/gkiarashv/xv6/blob/main/images/file2.png)


# User mode 

## uniq
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/uniquserex1.png)

## uniq -c
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/uniquserex2.png)


## uniq -d -c -i
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/uniquserex3.png)

## uniq file1
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/uniquserex4.png)

## uniq file1 -c
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/uniquserex5.png)

## uniq file1 -c -i
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/uniquserex6.png)

## uniq file1 -c -d -i
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/uniquserex7.png)

## uniq -c -d -i file1 file2
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/uniquserex8.png)




# Kernel 

## uniq
![headkernelex1](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex1.png)

## cat file1 | uniq
![headkernelex1](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex10.png)

## cat file1 | uniq -d -c -i
![headkernelex1](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex11.png)

## uniq file1
![headkernelex2](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex2.png)

## uniq -i file1
![headkernelex3](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex3.png)

## uniq -d file1 
![headkernelex4](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex4.png)

## uniq -c file1
![headkernelex5](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex5.png)

## uniq -d -c -i file1
![headkernelex6](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex6.png)

## uniq -d -c -i file1 file2
![headkernelex6](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex7.png)















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

## uniq -i
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/uniquserex3.png)

## uniq -i -c
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/uniquserex4.png)

## cat file1 | uniq
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/uniquserex5.png)

## cat file1 | uniq -c
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/uniquserex6.png)

## cat file1 | uniq -i
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/uniquserex7.png)

## cat file1 | uniq -d
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/uniquserex9.png)

## cat file1 | uniq -c -i
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/uniquserex8.png)

## uniq file1 file2
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/uniquserex10.png)

## uniq file1 file2 -d -c -i
![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/uniquserex11.png)




# Kernel 

## uniq
![headkernelex1](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex1.png)

## uniq file1 file2
![headkernelex1](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex10.png)

## uniq file1 file2 -d -c -i
![headkernelex1](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex11.png)

## uniq -c
![headkernelex2](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex2.png)

## uniq -i
![headkernelex3](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex3.png)

## uniq -i -c
![headkernelex4](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex4.png)

## cat file1 | uniq
![headkernelex5](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex5.png)

## cat file1 | uniq -c
![headkernelex6](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex6.png)

## cat file1 | uniq -i
![headkernelex6](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex7.png)

## cat file1 | uniq -d
![headkernelex6](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex8.png)

## cat file1 | uniq -d -c -i
![headkernelex6](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex9.png)

## uniq file1 file2
![headkernelex6](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex10.png)

## uniq file1 file2 -d -c- -i
![headkernelex6](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex11.png)















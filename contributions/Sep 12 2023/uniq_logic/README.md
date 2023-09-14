![file1](https://github.com/gkiarashv/xv6/blob/main/images/uniqlogic1.png)
![file1](https://github.com/gkiarashv/xv6/blob/main/images/uniqlogic2.png)


## Logic
The logic in the implementation of this code is to maintain two buffers, namely `line1` and `line2`. Except for the first line which is read into `line1`, the other lines
are read into `line2`. At each step, `line1` and `line2` are compared and the passed options are processed. The comparing can be done in two ways: considering the case using `compare_str()` or ignoring the case using `compare_str_ic()`. Based on the comparison, if the two lines are not equal, we ignore it in the basic uniq command because it should be filtered and we consider it by `isRepeted=1` for the case that we have used `-d` with the uniq command. Upon reaching a line that is different, we have to flush out the buffers. If `-d` is used, we should only print `line1` as `line2` has a content that is occured for the first time. To print `line1` we consider the possible options passed such as `-c`. If `-d` is not used, then we consider other options such as `-c` for printing. However, there is a special case which is the last line. Since we always print `line1`, there is a case that the last line is read into `line2` and we reach EOF. To address this case, we check if have reached EOF, we flush the `line2` as well.




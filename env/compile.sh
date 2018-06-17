#!/bin/bash
# fileName: compile.sh
# Date: Sun 17 Jun 2018 05:12:05 PM CST
# Author: light

# link arm-gcc
[ ! -f /usr/bin/arm-linux-gnueabi-gcc ] && ln -s /usr/bin/arm-linux-gnueabi-gcc-4.9 /usr/bin/arm-linux-gnueabi-gcc

# compile busybox
cd /root/busybox-1.20.2/
[ ! -f include/.libbb.h ] && cp include/libbb.h include/.libbb.h
sed  '43i #include<sys/resource.h>' include/.libbb.h > include/libbb.h
make defconfig
make CROSS_COMPILE=arm-linux-gnueabi-
make install CROSS_COMPILE=arm-linux-gnueabi-

# compile kernel
cd /root/linux-3.16/
make CROSS_COMPILE=arm-linux-gnueabi- ARCH=arm vexpress_defconfig
make CROSS_COMPILE=arm-linux-gnueabi- ARCH=arm

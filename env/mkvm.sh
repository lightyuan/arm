#!/bin/bash
# fileName: mkvm.sh
# Date: Sun 17 Jun 2018 05:13:40 PM CST
# Author: light

# collect files to rootfs/
cd /root/
mkdir -p vm/rootfs/{proc,etc/init.d,sys,tmp,root,var,mnt,lib,dev}
cp busybox-1.20.2/_install/* vm/rootfs/ -r
cp busybox-1.20.2/examples/bootfloppy/etc/* vm/rootfs/etc/ -r
cp /usr/arm-linux-gnueabi/lib/* vm/rootfs/lib/ -Pr


dd if=/dev/zero of=a9rootfs.ext3 bs=1M count=32
mkfs.ext3 a9rootfs.ext3
mv a9rootfs.ext3 vm/a9rootfs.ext3

cp linux-3.16/arch/arm/boot/dts/vexpress-v2p-ca9.dtb vm/
cp linux-3.16/arch/arm/boot/zImage vm/

# generate boot.sh mkrootfs.sh
cat > vm/boot.sh << EOF
qemu-system-arm -M vexpress-a9 -m 512M -kernel  ./zImage -dtb ./vexpress-v2p-ca9.dtb -nographic -append "root=/dev/mmcblk0  console=ttyAMA0" -sd a9rootfs.ext3
EOF

cat > vm/mkrootfs.sh << EOF
sudo mknod ./rootfs/dev/tty1 c 4 1
sudo mknod ./rootfs/dev/tty2 c 4 2
sudo mknod ./rootfs/dev/tty3 c 4 3
sudo mknod ./rootfs/dev/tty4 c 4 4

mkdir tmpfs
sudo mount -t ext3 a9rootfs.ext3 tmpfs/ -o loop
sudo cp rootfs/* tmpfs/ -r
sudo umount tmpfs/
EOF

# tar
tar cjf vm.tar.bz2 vm/
rm -fr vm

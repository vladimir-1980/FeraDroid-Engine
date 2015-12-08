#!/system/bin/sh
### FeraDroid Engine v0.19 | By FeraVolt. 2015 ###

B=/system/engine/bin/busybox

$B echo "Memory gear"
RAM=$((`$B free | $B awk '{ print $2 }' | $B sed -n 2p`/1024))
KB=$((($RAM/64+1)*128))
BDI=/sys/devices/virtual/bdi/*
STL=/sys/block/stl*/bdi
BML=/sys/block/bml*/bdi
MMC=/sys/block/mmc*/bdi
ZRM=/sys/block/zram*/bdi
MTD=/sys/block/mtd*/bdi
RAM=/sys/block/ram*/bdi
LP=/sys/block/loop*/bdi
$B echo "Device with $RAM MB of RAM"
$B echo "Calculated readahead parameter based on your RAM is $KB KB"

if [ -e /mnt/sd-ext ]; then
 $B echo "Mounting EXT partitions"
 $B mount -t ext3 -o rw /dev/block/vold/179:2 /mnt/sd-ext
 $B mount -t ext3 -o rw /dev/block/mmcblk0p2 /mnt/sd-ext
 $B sleep 1
 $B mount -t ext4 -o rw /dev/block/vold/179:2 /mnt/sd-ext
 $B mount -t ext4 -o rw /dev/block/mmcblk0p2 /mnt/sd-ext
 $B sleep 1
fi;

for i in $BDI $STL $BML $MMC $ZRM $MTD $RAM; do
if [ -e ${i}/read_ahead_kb ]; then
$B echo "Applying parameters.."
$B echo $KB > ${i}/read_ahead_kb;
fi;
done

$B echo $KB > /sys/block/mmcblk0/queue/read_ahead_kb
CHK=$($B cat /sys/devices/virtual/bdi/179:0/read_ahead_kb)
$B echo "Checking if worked. Current parameter is $CHK KB"
$B echo "Check"
$B sleep 1
$B sync;


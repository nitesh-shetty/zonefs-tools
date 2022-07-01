#!/bin/bash
#
# SPDX-License-Identifier: GPL-2.0-or-later
#

. scripts/test_lib

if [ $# == 0 ]; then
	echo "Copy file range test"
	exit 0
fi

echo "Check copy file range"

zonefs_mkfs "$1"
zonefs_mount "$1"

#writing to source file 
dd if=/dev/zero of="$zonefs_mntdir"/seq/2 oflag=direct bs=8192 count=1 || \
	exit_failed " --> FAILED"

#writing to destination file
dd if=/dev/zero of="$zonefs_mntdir"/seq/3 oflag=direct bs=4096 \
	count=1 || exit_failed " --> FAILED"

#copying to destination file at offset from where it is empty with
#first 4096 bytes of source file
tools/zio --copy --size=4096 --ofst_d=4096 \
	"$zonefs_mntdir"/seq/2 "$zonefs_mntdir"/seq/3 || \
	exit_failed " --> FAILED"

sz=$(file_size "$zonefs_mntdir"/seq/3)
echo "$sz"

compare=$(cmp "$zonefs_mntdir"/seq/2 "$zonefs_mntdir"/seq/3)
echo "$compare"

zonefs_umount

exit 0

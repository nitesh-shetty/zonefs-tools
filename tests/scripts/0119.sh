#!/bin/bash
#
# SPDX-License-Identifier: GPL-2.0-or-later

. scripts/test_lib

if [ $# == 0 ]; then
	echo "Failing Copy file range test"
        exit 0
fi

echo "Check copy file range"

zonefs_mkfs "$1"
zonefs_mount "$1"

# writing to source file
dd if=/dev/zero of="$zonefs_mntdir"/seq/2 oflag=direct bs=4096 count=1 || \
	        exit_failed " --> FAILED"

# writing to destination file
dd if=/dev/zero of="$zonefs_mntdir"/seq/3 oflag=direct bs=409600 \
	count=1 || exit_failed " --> FAILED"

# overwriting the destination file at a given offset
tools/zio --copy --ofst_d=4096 \
	"$zonefs_mntdir"/seq/2 "$zonefs_mntdir"/seq/3 && \
	exit_failed " --> FAILED"

sz=$(file_size "$zonefs_mntdir"/seq/3)
echo "$sz"

compare=$(cmp "$zonefs_mnt"/seq/2 "$zonefs_mnt"/seq/3)
echo "$sz"

zonefs_umount

exit 0

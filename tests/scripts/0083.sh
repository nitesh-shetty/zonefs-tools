#!/bin/bash
#
# SPDX-License-Identifier: GPL-2.0-or-later
#
# Copyright (C) 2019 Western Digital Corporation or its affiliates.
#

. scripts/test_lib

if [ $# == 0 ]; then
	echo "Files owner (set value + aggr_cnv)"
        exit 0
fi

require_cnv_files

echo "Check for UID 1000, GID 0, aggr_cnv"

zonefs_mkfs "-o aggr_cnv,uid=1000 $1"
zonefs_mount "$1"
check_uid_gid "1000" "0"
zonefs_umount

echo "Check for UID 0, GID 1000, aggr_cnv"

zonefs_mkfs "-o aggr_cnv,gid=1000 $1"
zonefs_mount "$1"
check_uid_gid "0" "1000"
zonefs_umount

echo "Check for UID 1000, GID 2000, aggr_cnv"

zonefs_mkfs "-o aggr_cnv,uid=1000,gid=2000 $1"
zonefs_mount "$1"
check_uid_gid "1000" "2000"
zonefs_umount

exit 0

#!/bin/bash
#
# SPDX-License-Identifier: GPL-2.0
#
# Copyright (C) 2019 Western Digital Corporation or its affiliates.
#

. scripts/test_lib

if [ $# == 0 ]; then
	echo "Number of files (aggr_cnv)"
        exit 0
fi

if [ "$nr_cnv_zones" == 0 ]; then
        num_cnv_files=0
        num_seq_files=$(( nr_seq_zones - 1 ))
elif [ "$nr_cnv_zones" == 1 ]; then
        num_cnv_files=0
        num_seq_files=$nr_seq_zones
else
        num_cnv_files=1
        num_seq_files=$nr_seq_zones
fi

echo "Check for number of files: $num_cnv_files aggr_cnv, $num_seq_files seq"

zonefs_mkfs "-o aggr_cnv $1"
zonefs_mount "$1"

if [ "$num_cnv_files" != 0 ]; then
	nr_files=$(ls "$zonefs_mntdir/cnv/" | wc -l)
	if [ "$nr_files" != "$num_cnv_files" ]; then
		echo " --> Invalid number of conventional zones file:"
		echo " --> Expected $num_cnv_files, got $nr_files"
		exit 1
	fi
fi

nr_files=$(ls "$zonefs_mntdir/seq/" | wc -l)
if [ "$nr_files" != "$num_seq_files" ]; then
	echo " --> Invalid number of sequential zones file:"
	echo " --> Expected $num_seq_files, got $nr_files"
	exit 1
fi

zonefs_umount

exit 0

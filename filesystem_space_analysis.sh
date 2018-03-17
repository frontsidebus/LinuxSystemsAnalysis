#!/bin/bash
#
# Adapted from the below 1-liner
#
#FS='./';resize;clear;date;df -h $FS_MP; echo "Largest Directories:"; nice -n19 find $FS_MP -mount -type d -print0 2>/dev/null|xargs -0 du -k|sort -runk1|head -n20|awk '{printf "%8d MB\t%s\n",($1/1024),$NF}';echo "Largest Files:"; nice -n 19 find $FS_MP -mount -type f -print0 2>/dev/null| xargs -0 du -k | sort -rnk1| head -n20 |awk '{printf "%8d MB\t%s\n",($1/1024),$NF}';
#
#
FS_MP=/home/lab-admin/
TMPFILE=/tmp/fs_space_details.tmp
OUTFILE=/root/fs_space_details.txt
#
main() {
	echo -e "$(date)\nLargest Directories:" > $TMPFILE
	#main part, lots of find'n here, but we nice the proc so that we don't asplode the guest
	nice -n19 find $FS_MP -mount -type d -print0 2>/dev/null|xargs -0 du -k|sort -runk1|head -n20|awk '{printf "%8d MB\t%s\n",($1/1024),$NF}' >> $TMPFILE
	echo "Largest Files:" >> $TMPFILE
	nice -n 19 find $FS_MP -mount -type f -print0 2>/dev/null| xargs -0 du -k | sort -rnk1| head -n20 |awk '{printf "%8d MB\t%s\n",($1/1024),$NF}' >> $TMPFILE
}
#
cleanup() {
	cat $TMPFILE > $OUTFILE
	echo "...report exported to $OUTFILE"
	rm $TMPFILE
	echo "...temp file $TMPFILE removed"
	cat $OUTFILE
}
#
#set the filesystem as user input if not defined
if [ -z "FS_MP" ] ; then
	echo "...enter the mount point or path where you want to analyze space: "
	read FS_MP
fi
#set the output file too if not defined
if [ -z "OUTFILE" ]; then
	echo "...enter the path for the output file (like '/root/fs_space_details.txt'): "
	read OUTFILE
fi
main
cleanup

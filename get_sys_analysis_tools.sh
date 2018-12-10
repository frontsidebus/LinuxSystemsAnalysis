#!/bin/bash
#
# Simple script used to install tools for systems analysis on linux machines. 
# Use on debian or fedora based flavors
# 
# You'll want to run this as root 
#
# assign your temp filehere, so we can keep a package list to clean up later
LISTFILE=/tmp/tools.txt
#log for debugging
LOGFILE=log.txt

# list of packages we can add to later if needed
declare -a packages=("atop" "blktrace" "dstat" "dtrace" "free" "iperf" "pidstat" "perf" "ping" "pidstat" "mpstat" "iostat" "iotop" "iftop" "ip" "netstat" "nicstat" "sar" "strace" "slabtop" "top" "stap" "tcpdump")

# list of package managers we can add to later if needed
declare -a pkgmgrs=("dnf" "yum" "aptitude")

PKG_MGR=$(for i in "${pkgmgrs[@]}"
	do
		which $i 2>/dev/null | cut -d "/" -f 4
	done
)

echo $PKG_MGR

# check for installed packages, keep track of any missing binaries
check_installed() {
	for package in "${packages[@]}"
	do 
		if which $package &>/dev/null; then
			echo "$package found"
		else
			echo "$package not found"
			echo "$package" >> $LISTFILE
		fi
	done 
}

yum_install_missing() {
	while read line; do
		#echo "...dubug inside yum install missing function"
		echo "installing utility " $line
		yum install -y $line
	done <$LISTFILE
}

apt_install_missing() {
	while read line; do
		#echo "...dubug inside apt install missing function"
		echo "installing utility " $line
		apt-get install $line
	done <$LISTFILE
}



# clean up our temp file
cleanup() {
	rm -f $LISTFILE
}

if [[ $PKG_MGR == *"yum"* ]]; then
	echo "using yum.. call function here"
fi

cleanup

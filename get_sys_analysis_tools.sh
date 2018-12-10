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
declare -a pkgmgrs=("dnf" "yum" "aptitude" )

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

# get the package manager
set_pkg_mgr() {
	for pkgmgr in "${pkgmgrs[@]}"
	do
		which $pkgmgr &>/dev/null
		RESULT=$?
			if [ $RESULT -eq 0 ]; then
				## Log which package manager we are using
				echo "...system is using $pkgmgr"
			else
				echo "...unrecognized or missing package manager"
				exit 1
			fi
	done
}

# clean up our temp file
cleanup() {
	rm -f $LISTFILE
}

set_pkg_mgr
cleanup

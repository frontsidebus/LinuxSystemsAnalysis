#!/bin/bash
#
#
get_distro () {
	lsb_release -ds 2>/dev/null || cat /etc/*release 2>/dev/null | head -n1 || uname -om
}
get_package_manager () {
	pkg_manager=( dnf yum aptitude )
	for i in "${pkg_manager[@]}"
	do
		which $i 2>/dev/null
	done
}
get_distro
get_package_manager

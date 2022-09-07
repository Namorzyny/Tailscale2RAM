#!/bin/sh

# DETECT ARCHITECTURE
ARCH=`uname -m`
if [ "$ARCH" == "mips" ]; then
	LE=`echo -n I | hexdump -o | awk '{ print (substr($2,6,1)=="1") ? "le" : ""; exit }'`
	ARCH="mips${LE}"
elif [ "$ARCH" == "armv7l" ]; then
	ARCH=arm
elif [ "$ARCH" == "aarch64" ]; then
	ARCH=arm64
elif [ "$ARCH" == "x86_64" ]; then
	ARCH=amd64
fi

# DOWNLOAD TAILSCALE
if [ ! -f /tmp/usr/bin/tailscaled ]; then
	echo 'Fetching package list...'
	PACKAGE_NAME=''
	until [ ! -z $PACKAGE_NAME ]
	do
		PACKAGE_NAME=$( \
			wget -O - https://pkgs.tailscale.com/stable 2> /dev/null | \
			grep -oE "tailscale_[0-9.]+_${ARCH}" | \
			tail -n 1 \
		)
		if [ -z $PACKAGE_NAME ]; then
			echo 'Fail to fetch latest packages, retrying...'
		fi
	done
	echo "Found ${PACKAGE_NAME}."

	echo "Downloading ${PACKAGE_NAME}..."
	RESULT=1
	until [ $RESULT -eq 0 ]
	do
		wget -O - https://pkgs.tailscale.com/stable/${PACKAGE_NAME}.tgz 2> /dev/null | \
			tar x -zvf - -C /tmp
		RESULT=$?
		if [ $RESULT -gt 0 ]; then
			echo 'Fail to download the package, retrying...'
		fi
	done

	mkdir -p /tmp/usr/bin
	mv /tmp/${PACKAGE_NAME}/tailscale* /tmp/usr/bin
	echo 'Cleaning...'
	if [ -z $PACKAGE_NAME ]; then
		rm -rf /tmp/${PACKAGE_NAME}
	fi
fi

# CALL TAILSCALED
/tmp/usr/bin/tailscaled "$@"

#!/bin/sh

# TEST IF TAILSCALE EXIST
/tmp/usr/bin/tailscale version > /dev/null
if [ $? -gt 0 ]; then
	echo 'Load and start tailscaled first.'
	exit 1
fi

# CALL TAILSCALE
/tmp/usr/bin/tailscale "$@"

# Tailscale2RAM

This project contains a set of Tailscale script for some devices that runs OpenWRT with not enough flash space.

## Install

1. Upload, download or clone to somewhere like `/root/tailscale`
2. Run `chmod +x tailscale*` and `sh install.sh`
3. Run `/etc/init.d/tailscaled start`, and wait for a moment.
4. Run `tailscale up`, and enjoy.

## Tips

- If you want to connect to your tailscale network through your router, just add an interface with device `tailscale0`. Then assign a firewall zone `WAN` that allows packages forward to the tailscale network.

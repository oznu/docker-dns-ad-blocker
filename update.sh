#!/bin/sh

# Download the checksum on the remote release
CHECKSUM=$(curl -k "https://raw.githubusercontent.com/oznu/dns-zone-blacklist/master/dnsmasq/dnsmasq.blacklist.checksum")

# Compare the remote checksum to the local file
echo "${CHECKSUM}  /etc/dnsmasq.blacklist" | sha256sum -c -

if [[ $? != 0 ]] ; then
  # Update Available, download it before restarting the container to reduce down time
  curl -k -o /etc/dnsmasq.blacklist "https://raw.githubusercontent.com/oznu/dns-zone-blacklist/master/dnsmasq/dnsmasq.blacklist"

  # Kill the main process. Docker will bring back up the container when restart=always is set.
  pkill dnsmasq
fi

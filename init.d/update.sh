#!/bin/sh

# Download the checksum on the remote release
CHECKSUM=$(curl -sk "$BLACKLIST_URL.checksum")

# Compare the remote checksum to the local file
echo "${CHECKSUM}  /etc/dnsmasq.blacklist" | sha256sum -cs -

if [[ $? != 0 ]] ; then
  # Update Available, download it before restarting the container to reduce down time
  curl --progress -k -o /etc/dnsmasq.blacklist "$BLACKLIST_URL"

  # Kill the main process. Docker will bring back up the container when restart=always is set.
  pkill dnsmasq
fi

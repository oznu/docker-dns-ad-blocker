#!/bin/sh

# Set default blacklist branch
BRANCH="${BRANCH:-master}"

# Set default URL
BLACKLIST_URL="${BLACKLIST_URL:-https://raw.githubusercontent.com/oznu/dns-zone-blacklist/$BRANCH/dnsmasq/dnsmasq.blacklist}"
echo "Blacklist Url: $BLACKLIST_URL"

# Download the checksum on the remote release
CHECKSUM=$(curl -k "$BLACKLIST_URL.checksum")

# Compare the remote checksum to the local file
echo "${CHECKSUM}  /etc/dnsmasq.blacklist" | sha256sum -c -

if [[ $? != 0 ]] ; then
  # Update Available, download it before restarting the container to reduce down time
  curl -k -o /etc/dnsmasq.blacklist "$BLACKLIST_URL"

  # Kill the main process. Docker will bring back up the container when restart=always is set.
  pkill dnsmasq
fi

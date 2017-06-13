#!/bin/sh

echo "Blacklist branch: $BRANCH"
echo "Blacklist URL: $BLACKLIST_URL"
echo "Forward Name Servers: $NS1, $NS2"
echo "Debug Level: $DEBUG"
echo "Auto Update: $AUTO_UPDATE"

sed -i "s/server=.* # NS1.*/server=$NS1 # NS1/" /etc/dnsmasq.conf
sed -i "s/server=.* # NS2.*/server=$NS2 # NS2/" /etc/dnsmasq.conf

# Set the containers name servers - so it can download the blacklist even if the host is using this container as DNS.
echo "nameserver $NS1" > /etc/resolv.conf
echo "nameserver $NS2" >> /etc/resolv.conf

# Enable/Disable Debug Mode
if [[ "$DEBUG" -eq "1" ]]; then
  sed -i "s/.*log-queries.*/log-queries/" /etc/dnsmasq.conf
elif [[ "$DEBUG" -eq "2" ]]; then
  sed -i "s/.*log-queries.*/log-queries=extra/" /etc/dnsmasq.conf
else
  sed -i "s/.*log-queries.*/#log-queries/" /etc/dnsmasq.conf
fi

# Download the checksum on the remote release
CHECKSUM=$(curl -sk "$BLACKLIST_URL.checksum")

# Compare the remote checksum to the existing local file
echo "${CHECKSUM}  /etc/dnsmasq.blacklist" | sha256sum -cs -

if [[ $? != 0 ]] ; then
  echo "Blacklist is missing or out of date, downloading update..."
  # Get the blacklist of domains and fix the zone file path.
  curl --progress -k -o /etc/dnsmasq.blacklist "$BLACKLIST_URL"
fi

echo "BLOCKING $(cat /etc/dnsmasq.blacklist | wc -l) BLACKLISTED DOMAINS."

# Enable/Disable Auto Update Mode
if [[ "$AUTO_UPDATE" -eq "1" ]]; then
  echo "0	*	*	*	*	/init.d/update.sh" > /var/spool/cron/crontabs/root
  /usr/sbin/crond -b
else
  > /var/spool/cron/crontabs/root
fi

exec "$@"

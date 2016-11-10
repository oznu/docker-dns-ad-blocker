#!/bin/sh

# Get the blacklist of domains and fix the zone file path.
wget "https://raw.githubusercontent.com/oznu/dns-zone-blacklist/master/dnsmasq/dnsmasq.blacklist" -O /etc/dnsmasq.blacklist --no-check-certificate

# Setup Forward Lookup Name Servers
NS1="${NS1:-8.8.8.8}"
NS2="${NS2:-8.8.4.4}"

sed -i "s/server=.* # NS1.*/server=$NS1 # NS1/" /etc/dnsmasq.conf
sed -i "s/server=.* # NS2.*/server=$NS2 # NS2/" /etc/dnsmasq.conf

# Enable/Disable Debug Mode
if [[ "$DEBUG" -eq "1" ]]; then
  sed -i "s/.*log-queries/log-queries/" /etc/dnsmasq.conf
else
  sed -i "s/.*log-queries/#log-queries/" /etc/dnsmasq.conf
fi

exec "$@"

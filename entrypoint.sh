#!/bin/sh

# Get the blacklist of domains and fix the zone file path.
wget "https://raw.githubusercontent.com/oznu/dns-zone-blacklist/master/dnsmasq/dnsmasq.blacklist" -O /etc/dnsmasq.blacklist --no-check-certificate

exec "$@"

#!/bin/bash

# Get the blacklist of domains and fix the zone file path.
wget "http://pgl.yoyo.org/as/serverlist.php?hostformat=bindconfig&showintro=0&mimetype=plaintext" -O /etc/bind/zones.blacklist
sed -i  's/null.zone.file/\/etc\/bind\/null.zone.file/g' /etc/bind/zones.blacklist

# Prepare the zones.custom file to by ensuring it is empty.
> /etc/bind/zones.custom

# For each file in the /etc/bind/zones directory, create an entry in the /etc/bind/zones.custom file.
cd /etc/bind/zones
for zone in *; do
  echo "Adding custom zone $zone..."
  echo "zone \"$zone\" { type master; file \"/etc/bind/zones/$zone\"; };" >> /etc/bind/zones.custom
done
cd /etc/bind

exec "$@"

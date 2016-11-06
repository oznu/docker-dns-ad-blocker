#!/bin/bash

wget "http://pgl.yoyo.org/as/serverlist.php?hostformat=bindconfig&showintro=0&mimetype=plaintext" -O /etc/bind/zones.blacklist
sed -i  's/null.zone.file/\/etc\/bind\/null.zone.file/g' /etc/bind/zones.blacklist

exec "$@"

[![Docker Build Status](https://img.shields.io/docker/build/oznu/dns-ad-blocker.svg?label=x64%20build&style=for-the-badge)](https://hub.docker.com/r/oznu/dns-ad-blocker/) [![Travis](https://img.shields.io/travis/oznu/docker-dns-ad-blocker.svg?label=arm%20build&style=for-the-badge)](https://travis-ci.org/oznu/docker-dns-ad-blocker) [![Docker Pulls](https://img.shields.io/docker/pulls/oznu/dns-ad-blocker.svg?style=for-the-badge)](https://hub.docker.com/r/oznu/dns-ad-blocker/)

# oznu/dns-ad-blocker

A simple, lightweight, dnsmasq DNS server to block traffic to known ad servers.

## Usage

Quick Setup:

```
docker run -d -p 53:53/tcp -p 53:53/udp oznu/dns-ad-blocker
```

Raspberry Pi:

```
docker run -d -p 53:53/tcp -p 53:53/udp oznu/dns-ad-blocker:armhf
```

You can now set your devices to use the Docker Host's IP Address as the primary DNS resolver,
if you are using [Docker for Windows](https://docs.docker.com/docker-for-windows/) or [Docker for Mac](https://docs.docker.com/docker-for-mac/) this will be 127.0.0.1.

Automatic blacklist updates are enabled by default.

## Parameters

```shell
docker run --restart=always \
  -p 53:53/tcp -p 53:53/udp \
  -e DEBUG=0 \
  -e NS1=1.1.1.1 -e NS2=1.0.0.1 \
  -e AUTO_UPDATE=1 \
  -e BRANCH=master \
  -e DNSCRYPT=0 \
  -v </path/to/config>:/config \
  oznu/dns-ad-blocker
```

The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side.

* `--restart=always` - ensure the container restarts automatically after host reboot.
* `-p 53:53/tcp -p 53:53/udp` - expose port 53 on TCP and UDP to the host, **required**.
* `-e DEBUG` - enables debug mode if set to `-e DEBUG=1`. For verbose logging (including source IP) set `-e DEBUG=2`.
* `-e NS1 -e NS2` - override the default forward lookup servers. Defaults to Cloudflares's DNS servers (1.1.1.1, 1.0.0.1).
* `-e AUTO_UPDATE` - to disable automatic updates to the blacklist set `-e AUTO_UPDATE=0`. Automatic updates are enabled by default.
* `-e BLACKLIST_URL` - the url where the blacklist should be downloaded from, useful if you want to lock the blacklist to a specific branch.
* `-e WHITELIST` - a list of domains to exclude from the blacklist (comma separated, no spaces) eg. `-e WHITELIST=www.oz.nu,hub.docker.com`
* `-e DNSCRYPT=1` - enable [DNSCrypt](https://dnscrypt.info/), disabled by default. See below for more details.
* `-v /config` - any files with the `.conf` suffix included in the mounted volume will be included in the dnsmasq config.

## AD Blocking

This image is using the blacklists created by [oznu/dns-zone-blacklist](https://github.com/oznu/dns-zone-blacklist) and [StevenBlack/hosts](https://github.com/StevenBlack/hosts).

The DNS server works by returning ```NXDOMAIN``` when a DNS lookup is made by a browser or device to a blacklisted domain. This tells the browser the DNS record for domain name could not be found which means the browser won't even attempt a connection.

If you have found a host you think should be blacklisted please submit an issue on the upstream blacklist, [StevenBlack/hosts](https://github.com/StevenBlack/hosts/issues), as
the aim of this project is not to maintain yet another blacklist.

## DNSCrypt

[DNSCrypt](https://dnscrypt.org/) is a protocol that authenticates communications between a DNS client and a DNS resolver. It uses cryptographic signatures to verify that responses originate from the chosen DNS resolver and haven't been tampered with.

*Note: Using DNSCrypt does not increase your privacy online and is not a replacement for a VPN. Even if you’re using HTTPS, your browser is sending the website hostname in plain text due to [SNI](https://en.wikipedia.org/wiki/Server_Name_Indication).*

This image allows you to enable [DNSCrypt](https://dnscrypt.org/) for your entire local network or individual workstation without having to install any other client software.

```
docker run  -d --restart=always -p 53:53/tcp -p 53:53/udp -e DNSCRYPT=1 oznu/dns-ad-blocker
```

* ```-e DNSCRYPT``` - To enable DNSCrypt set ```DNSCRYPT=1```. Disabled by default.
* ```-e DNS_CRYPT_SERVERS``` - a comma seperated (no spaces) list of servers to use. Defaults to `cloudflare,cloudflare-ipv6`.

**Enabling DNSCrypt will override the ```NS1``` and ```NS2``` forward lookup server options.**

See [the offical list of DNSCrypt resolvers](https://dnscrypt.info/public-servers) for alternative providers if you don't want to use Cloudflare DNS.

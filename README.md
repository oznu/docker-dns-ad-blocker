[![Docker Automated buil](https://img.shields.io/docker/automated/oznu/dns-ad-blocker.svg)](https://hub.docker.com/r/oznu/dns-ad-blocker/) [![Docker Pulls](https://img.shields.io/docker/pulls/oznu/dns-ad-blocker.svg)](https://hub.docker.com/r/oznu/dns-ad-blocker/) [![](https://images.microbadger.com/badges/image/oznu/dns-ad-blocker.svg)](https://hub.docker.com/r/oznu/dns-ad-blocker/)

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
  -e NS1=8.8.8.8 -e NS2=8.8.4.4 \
  -e AUTO_UPDATE=1 \
  -e BRANCH=master \
  -v </path/to/config>:/config \
  oznu/dns-ad-blocker
```

The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side.

* `--restart=always` - ensure the container restarts automatically after host reboot.
* `-p 53:53/tcp -p 53:53/udp` - expose port 53 on TCP and UDP to the host, **required**.
* `-e DEBUG` - enables debug mode if set to `-e DEBUG=1`. For verbose logging (including source IP) set `-e DEBUG=2`.
* `-e NS1 -e NS2` - override the default forward lookup servers. Defaults to Google's DNS servers (8.8.8.8, 8.8.4.4).
* `-e AUTO_UPDATE` - to disable automatic updates to the blacklist set `-e AUTO_UPDATE=0`. Automatic updates are enabled by default.
* `-e BLACKLIST_URL` - the url where the blacklist should be downloaded from, useful if you want to lock the blacklist to a specific branch.
* `-e WHITELIST` - a list of domains to exclude from the blacklist (comma separated, no spaces) eg. `-e WHITELIST=www.oz.nu,hub.docker.com`
* `-v /config` - any files included in the mounted volume will be included in the dnsmasq config.

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
* ```-e DNSCRYPT_RESOLVER_ADDR``` - the DNSCrypt-capable resolver IP address with an optional port. Defaults to OpenDNS (208.67.220.220:443).
* ```-e DNSCRYPT_PROVIDER_NAME``` -  the fully-qualified name of the DNSCrypt certificate provider. Defaults to OpenDNS (2.dnscrypt-cert.opendns.com).
* ```-e DNSCRYPT_PROVIDER_KEY``` - the DNSCrypt provider public key. Defaults to OpenDNS.

**Enabling DNSCrypt will override the ```NS1``` and ```NS2``` forward lookup server options.**

See [offical list of DNSCrypt resolvers](https://github.com/jedisct1/dnscrypt-proxy/blob/master/dnscrypt-resolvers.csv) for alternative providers if you don't want to use OpenDNS.

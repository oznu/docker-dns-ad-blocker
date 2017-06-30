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

* ```--restart=always``` - ensure the container restarts automatically after host reboot.
* ```-p 53:53/tcp -p 53:53/udp``` - expose port 53 on TCP and UDP to the host, **required**.
* ```-e DEBUG``` - enables debug mode if set to ```DEBUG=1```. For verbose logging (including source IP) set ```DEBUG=2```.
* ```-e NS1 -e NS2``` - override the default forward lookup servers. By default these are set to Google's DNS servers.
* ```-e AUTO_UPDATE``` - to disable automatic updates to the blacklist set ```AUTO_UPDATE=0```. Automatic updates are enabled by default.
* ```-e BLACKLIST_URL``` - the url where the blacklist should be downloaded from, useful if you want to lock the blacklist to a specific branch.
* ```-v /config``` - any files included in the mounted volume will be included in the dnsmasq config.

## AD Blocking

This image is using the blacklists created by [oznu/dns-zone-blacklist](https://github.com/oznu/dns-zone-blacklist) and [StevenBlack/hosts](https://github.com/StevenBlack/hosts).

The DNS server works by returning ```NXDOMAIN``` when a DNS lookup is made by a browser or device to a blacklisted domain. This tells the browser the DNS record for domain name could not be found which means the browser won't even attempt a connection.

If you have found a host you think should be blacklisted please submit an issue on the upstream blacklist, [StevenBlack/hosts](https://github.com/StevenBlack/hosts/issues), as
the aim of this project is not to maintain yet another blacklist.

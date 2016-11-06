# oznu/dns-ad-blocker

A simple BIND DNS server to block traffic to known ad servers.

### Usage

```
docker run -d -p 53:53/tcp -p 53:53/udp oznu/dns-ad-blocker
```

### AD Blocking

This image is using the blacklists created by [http://pgl.yoyo.org/as/](http://pgl.yoyo.org/as/).

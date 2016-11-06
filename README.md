# oznu/dns-ad-blocker

A simple BIND DNS server to block traffic to known ad servers.

## Usage

```
docker run -d -p 53:53/tcp -p 53:53/udp oznu/dns-ad-blocker
```

## AD Blocking

This image is using the blacklists created by [http://pgl.yoyo.org/as/](http://pgl.yoyo.org/as/). The blacklist is updated every time the container is started.

## Optional :: Custom Domains

This image supports adding additional zones that may be used to serve internal DNS zones or to override existing zones.

To do this create a volume share when creating the container:

```
docker run -d -p 53:53/tcp -p 53:53/udp -v /srv/zones:/etc/bind/zones oznu/dns-ad-blocker
```

Every file in the ```/srv/zones``` should have the name of the zone you wish to add.
For example, if you were adding the zone ```example.com.au```, the file name should be named ```example.com.au```.

The file contents should be a bind zone file, for example:

```
$TTL    86400   ; one day

@       IN      SOA     ns0.example.net.      hostmaster.example.net. (
                        2002061000       ; serial number YYMMDDNN
                        28800   ; refresh  8 hours
                        7200    ; retry    2 hours
                        864000  ; expire  10 days
                        86400 ) ; min ttl  1 day
                NS      ns0.example.net.
                NS      ns1.example.net.

                A       10.0.0.100

*       IN      A       10.0.0.100
```

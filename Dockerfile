FROM oznu/s6-alpine

RUN apk --no-cache add dnsmasq curl

COPY root /

VOLUME ["/config"]

EXPOSE 53 53/udp

ENV NS1=8.8.8.8 NS2=8.8.4.4 DEBUG=0 AUTO_UPDATE=1 \
  BLACKLIST_URL=https://raw.githubusercontent.com/oznu/dns-zone-blacklist/master/dnsmasq/dnsmasq-server.blacklist

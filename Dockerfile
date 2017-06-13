FROM alpine:3.6
RUN apk --no-cache add tzdata dnsmasq curl

RUN mkdir -p /etc/dnsmasq.d/ \
  && mkdir /init.d \
  && touch /etc/dnsmasq.blacklist

COPY config/dnsmasq.conf /etc/dnsmasq.conf
COPY init.d/ /init.d

VOLUME ["/etc/dnsmasq.d/"]

EXPOSE 53 53/udp

ENTRYPOINT ["/init.d/entrypoint.sh"]

ENV BRANCH=master
ENV BLACKLIST_URL https://raw.githubusercontent.com/oznu/dns-zone-blacklist/${BRANCH}/dnsmasq/dnsmasq-server.blacklist

ENV NS1=8.8.8.8 \
  NS2=8.8.4.4 \
  DEBUG=0 \
  AUTO_UPDATE=1

CMD ["dnsmasq", "--no-daemon"]

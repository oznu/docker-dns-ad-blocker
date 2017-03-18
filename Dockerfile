FROM alpine:3.4
RUN apk --no-cache add tzdata dnsmasq curl

EXPOSE 53 53/udp

RUN mkdir -p /etc/dnsmasq.d/
COPY config/dnsmasq.conf /etc/dnsmasq.conf

VOLUME ["/etc/dnsmasq.d/"]

RUN mkdir /init.d
COPY init.d/ /init.d
ENTRYPOINT ["/init.d/entrypoint.sh"]

CMD ["dnsmasq", "--no-daemon"]

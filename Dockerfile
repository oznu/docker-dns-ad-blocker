ARG S6_ARCH
FROM oznu/s6-alpine:3.7r2-${S6_ARCH:-amd64}

ENV DEBUG=0 \
  NS1=1.1.1.1 \
  NS2=1.0.0.1 \
  AUTO_UPDATE=1 \
  BLACKLIST_URL=https://raw.githubusercontent.com/oznu/dns-zone-blacklist/master/dnsmasq/dnsmasq-server.blacklist \
  DNS_CRYPT_SERVERS=cloudflare,cloudflare-ipv6 \
  DNSCRYPT_VERSION=2.0.14

RUN set -xe \
  && apk add --no-cache dnsmasq curl

# Install dnscrypt-proxy
RUN case "${QEMU_ARCH}" in \
    x86_64) PROXY_ARCH='i386';; \
    arm) PROXY_ARCH='arm';; \
    aarch64) PROXY_ARCH='arm64';; \
    *) echo "unsupported architecture"; exit 1 ;; \
  esac \
  && curl -fSLO "https://github.com/jedisct1/dnscrypt-proxy/releases/download/${DNSCRYPT_VERSION}/dnscrypt-proxy-linux_${PROXY_ARCH}-${DNSCRYPT_VERSION}.tar.gz" \
  && tar -xzf dnscrypt-proxy-linux_${PROXY_ARCH}-${DNSCRYPT_VERSION}.tar.gz \
  && mv linux-${PROXY_ARCH} /dnscrypt \
  && rm -rf dnscrypt-proxy-linux_${PROXY_ARCH}-${DNSCRYPT_VERSION}.tar.gz

COPY root /

VOLUME ["/config"]

EXPOSE 53 53/udp

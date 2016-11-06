FROM ubuntu:16.04

RUN apt-get -y update
RUN apt-get -y install bind9 bind9utils bind9-doc
RUN apt-get -y install dnsutils wget

COPY ./config/ /etc/bind/
COPY entrypoint.sh /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/named", "-g", "-d", "1"]

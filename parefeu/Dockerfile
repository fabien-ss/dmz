FROM alpine:latest

RUN apk update && apk add --no-cache \
    iptables \
    ip6tables \
    iproute2 \
    tcpdump \
    bash \
    squid

COPY entrypoint.sh /entrypoint.sh
COPY squid.conf /etc/squid/squid.conf
COPY blacklist.txt /etc/squid/blacklist.txt
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["sleep", "infinity"]

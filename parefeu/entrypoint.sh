#!/bin/bash
set -e

# eth0 = WAN, eth1 = DMZ, eth2 = LAN
for IFACE in eth0 eth1 eth2; do
    for i in $(seq 1 10); do
        if ip link show "$IFACE" > /dev/null 2>&1; then
            break
        fi
        sleep 0.5
    done
done

ip addr add 200.1.1.1/24    dev eth0 2>/dev/null || true
ip addr add 192.168.10.1/24 dev eth1 2>/dev/null || true
ip addr add 192.168.20.1/24 dev eth2 2>/dev/null || true

ip link set eth0 up
ip link set eth1 up
ip link set eth2 up

sysctl -w net.ipv4.ip_forward=1 2>/dev/null || echo 1 > /proc/sys/net/ipv4/ip_forward

echo "[entrypoint] Pare-feu-1 configuré :"
echo "  eth0 (WAN) : 200.1.1.1/24"
echo "  eth1 (DMZ) : 192.168.10.1/24"
echo "  eth2 (LAN) : 192.168.20.1/24"
echo "  ip_forward : activé"
echo "  iptables déjà installé — appliquer vos règles avec 'iptables -A ...'"

exec "$@"

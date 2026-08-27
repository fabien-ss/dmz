#!/bin/bash
set -e

IFACE="eth0"
IP_ADDR="192.168.10.10/24"
GATEWAY="192.168.10.1"

for i in $(seq 1 10); do
    if ip link show "$IFACE" > /dev/null 2>&1; then
        break
    fi
    sleep 0.5
done

ip addr add "$IP_ADDR" dev "$IFACE" 2>/dev/null || true
ip link set "$IFACE" up
ip route add default via "$GATEWAY" 2>/dev/null || true

echo "[entrypoint] ServeurWebDMZ-1 configuré : $IP_ADDR via $GATEWAY"

# Enchaîne vers l'entrypoint officiel de l'image nginx (gère la config par défaut)
exec /docker-entrypoint.sh "$@"

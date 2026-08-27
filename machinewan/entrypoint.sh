#!/bin/bash
set -e

IFACE="eth0"
IP_ADDR="200.1.1.2/24"
GATEWAY="200.1.1.1"

# Attendre que l'interface soit prête (GNS3 l'attache après le démarrage du conteneur)
for i in $(seq 1 10); do
    if ip link show "$IFACE" > /dev/null 2>&1; then
        break
    fi
    sleep 0.5
done

ip addr add "$IP_ADDR" dev "$IFACE" 2>/dev/null || true
ip link set "$IFACE" up
ip route add default via "$GATEWAY" 2>/dev/null || true

echo "[entrypoint] MachineWAN-1 configuré : $IP_ADDR via $GATEWAY"

exec "$@"

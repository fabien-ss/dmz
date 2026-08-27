#!/bin/bash
set -e

cd "$(dirname "$0")"

echo "== Build MachineWAN =="
docker build -t dmz-machinewan:latest ./machinewan

echo "== Build ClientLAN-1 =="
docker build -t dmz-clientlan1:latest ./clientlan1

echo "== Build ClientLAN-2 =="
docker build -t dmz-clientlan2:latest ./clientlan2

echo "== Build Pare-feu =="
docker build -t dmz-parefeu:latest ./parefeu

echo "== Build Serveur Web DMZ =="
docker build -t dmz-serveurwebdmz:latest ./serveurwebdmz

echo ""
echo "Images construites :"
docker images | grep dmz-

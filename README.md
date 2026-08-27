# Images Docker pré-configurées — TP DMZ

Chaque image configure automatiquement son adressage IP au démarrage du
conteneur (via `entrypoint.sh`), donc **plus besoin de retaper `ip addr add`
à chaque redémarrage dans GNS3**.

## 1. Construire les images

```bash
chmod +x build-all.sh
./build-all.sh
```

Ou individuellement :
```bash
docker build -t dmz-machinewan:latest      ./machinewan
docker build -t dmz-clientlan1:latest      ./clientlan1
docker build -t dmz-clientlan2:latest      ./clientlan2
docker build -t dmz-parefeu:latest         ./parefeu
docker build -t dmz-serveurwebdmz:latest   ./serveurwebdmz
```

## 2. Adressage intégré dans chaque image

| Image | Base | Interface(s) | IP | Passerelle |
|---|---|---|---|---|
| `dmz-machinewan` | nicolaka/netshoot | eth0 | 200.1.1.2/24 | 200.1.1.1 |
| `dmz-clientlan1` | nicolaka/netshoot | eth0 | 192.168.20.10/24 | 192.168.20.1 |
| `dmz-clientlan2` | nicolaka/netshoot | eth0 | 192.168.20.11/24 | 192.168.20.1 |
| `dmz-parefeu` | alpine:latest | eth0/eth1/eth2 | 200.1.1.1/24, 192.168.10.1/24, 192.168.20.1/24 | — |
| `dmz-serveurwebdmz` | nginx:alpine | eth0 | 192.168.10.10/24 | 192.168.10.1 |

Le pare-feu a en plus `iptables` préinstallé et `ip_forward` activé
automatiquement au démarrage — tu n'as plus qu'à appliquer tes règles
`iptables -A ...` directement dans la console GNS3.

Le serveur web a `nginx` qui démarre automatiquement après la config IP
(accessible immédiatement en HTTP sur le port 80).

## 3. Ajouter ces images dans GNS3

Pour chaque image, dans **Edit > Preferences > Docker containers > New** :

1. Choisis l'image correspondante (ex. `dmz-parefeu:latest`)
2. Renseigne le bon nombre d'interfaces réseau :
   - `dmz-parefeu` → **3** interfaces
   - Toutes les autres → **1** interface
3. Laisse le **Start command** vide (le `CMD` est déjà défini dans le Dockerfile)

## 4. Remplacer les nœuds existants sur le canvas

Supprime les anciens nœuds (`alpine:latest`, `nginx:alpine`, `nicolaka/netshoot`
génériques) et recrée-les à partir des nouveaux templates ci-dessus, en
conservant le même câblage que ta topologie actuelle.

## 5. Vérification après démarrage

Ouvre la console de chaque nœud — le message `[entrypoint] ... configuré`
doit s'afficher, confirmant l'IP appliquée. Un simple `ip a` confirme
ensuite que l'adresse persiste même après un `Stop`/`Start` dans GNS3
(puisqu'elle est réappliquée à chaque démarrage du conteneur, pas juste
une fois manuellement).

## Notes

- Ces images restent isolées (pas d'accès Internet réel) — c'est volontaire
  et conforme au sujet, qui ne demande pas de connectivité WAN réelle.
- Pour installer des paquets supplémentaires (`snort`, `squid`,
  `squidguard`) sur une image, ajoute-les dans le `RUN apk add ...` /
  `RUN apt install ...` du Dockerfile correspondant, puis rebuild.

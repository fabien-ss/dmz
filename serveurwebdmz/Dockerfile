FROM nginx:alpine

RUN apk update && apk add --no-cache iproute2 bash

RUN apk add --no-cache iproute2 openssh

# Generer les cles hote SSH + creer un utilisateur de test
RUN ssh-keygen -A && \
    adduser -D testuser && \
    echo "testuser:testpass" | chpasswd && \
    mkdir -p /run/sshd

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# On enchaîne vers l'entrypoint officiel de l'image nginx (gère la conf par défaut),
# qui termine par "nginx -g daemon off;" (CMD hérité de l'image de base).
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

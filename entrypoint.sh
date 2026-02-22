#!/bin/bash
set -e

# Configuration dynamique
if [ ! -z "$SSH_USER" ]; then
    echo "Création de l'utilisateur $SSH_USER"
    adduser -D $SSH_USER
    echo "$SSH_USER:$SSH_PASS" | chpasswd
fi

# Démarrer SSH
echo "Démarrage du serveur SSH sur le port 2222"
/usr/sbin/sshd -D -p 2222

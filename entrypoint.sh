#!/bin/bash
set -e

# Configuration dynamique
if [ ! -z "$SSH_USER" ]; then
    echo "Création de l'utilisateur $SSH_USER"
    # Pour Alpine Linux, la commande est adduser (pas useradd)
    adduser -D -s /bin/bash "$SSH_USER"
    echo "$SSH_USER:$SSH_PASS" | chpasswd
    
    # Configuration SSH pour l'utilisateur
    mkdir -p /home/$SSH_USER/.ssh
    chown $SSH_USER:$SSH_USER /home/$SSH_USER/.ssh
    chmod 700 /home/$SSH_USER/.ssh
fi

# Configuration supplémentaire pour permettre les tunnels
echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config
echo "GatewayPorts yes" >> /etc/ssh/sshd_config
echo "PermitTunnel yes" >> /etc/ssh/sshd_config

# Démarrer SSH sur le port 443 (pour passer à travers Cloud Run)
echo "Démarrage du serveur SSH sur le port 443"
exec /usr/sbin/sshd -D -p 443 -e

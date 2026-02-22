# Image de base légère avec Alpine Linux
FROM alpine:latest

# Installation des packages nécessaires
RUN apk add --no-cache \
    openssh-server \
    openssh-client \
    bash \
    curl \
    socat \
    tini \
    && ssh-keygen -A \
    && rm -rf /var/cache/apk/*

# Création des répertoires nécessaires
RUN mkdir -p /var/run/sshd /root/.ssh /home

# Configuration SSH de base
RUN echo 'root:changeme' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config && \
    echo "Port 443" >> /etc/ssh/sshd_config

# Script d'entrée
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Port SSH (443 pour Cloud Run)
EXPOSE 443

# Utiliser tini pour gérer les signaux
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/entrypoint.sh"]

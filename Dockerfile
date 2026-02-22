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
    && ssh-keygen -A

# Configuration SSH
RUN mkdir -p /var/run/sshd /root/.ssh
RUN echo 'root:changeme' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Script d'entrée
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Port SSH
EXPOSE 2222

# Utiliser tini pour gérer les signaux
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/entrypoint.sh"]

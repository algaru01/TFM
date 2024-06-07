# Usa la imagen base creada previamente
FROM debian-ipython:latest

USER jupyter

WORKDIR /home/jupyter

COPY docker-entrypoint.sh /tmp/docker-entrypoint.sh
ENTRYPOINT ["sh", "/tmp/docker-entrypoint.sh"]
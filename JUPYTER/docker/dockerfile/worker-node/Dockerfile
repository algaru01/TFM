# Usa la imagen base creada previamente
FROM debian-ipython:latest

USER jupyter

WORKDIR /home/jupyter

# Crear archivo de configuración para ipyparallel
COPY ipengine_config.py /home/jupyter/config/ipengine_config.py

COPY docker-entrypoint.sh /tmp/docker-entrypoint.sh
ENTRYPOINT ["sh", "/tmp/docker-entrypoint.sh"]
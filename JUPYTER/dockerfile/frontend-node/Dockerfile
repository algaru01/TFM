# Usa la imagen base creada previamente
FROM debian-ipython:latest

RUN pip install --break-system-packages jupyter

USER jupyter

WORKDIR /home/jupyter

# Crear archivo de configuración para ipyparallel
COPY jupyter_config.py /home/jupyter/.ipython/profile_default/jupyter_config.py

# Expone el puerto 8888 para acceder a Jupyter Notebook desde fuera del contenedor
EXPOSE 8888

COPY docker-entrypoint.sh /tmp/docker-entrypoint.sh
ENTRYPOINT ["sh", "/tmp/docker-entrypoint.sh"]

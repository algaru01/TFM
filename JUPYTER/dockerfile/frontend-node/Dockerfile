# Usa la imagen base de Debian
FROM debian-ipython:latest

RUN pip install --break-system-packages jupyter

USER jupyter

# Crea un directorio de trabajo
WORKDIR /home/jupyter

# Crear archivo de configuración para ipyparallel
RUN mkdir -p /home/jupyter/.ipython/profile_default/
COPY jupyter_config.py /home/jupyter/.ipython/profile_default/jupyter_config.py

# Expone el puerto 8888 para acceder a Jupyter Notebook desde fuera del contenedor
EXPOSE 8888

# Ejecuta Jupyter Notebook cuando se inicie el contenedor
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888"]

# Usa la imagen base de Debian
FROM debian:latest

# Actualiza el índice de paquetes e instala las dependencias necesarias
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    apt-get clean

RUN apt-get install -y iproute2 iputils-ping vim

# Instala Jupyter Notebook
RUN pip install --break-system-packages jupyter

RUN pip install --break-system-packages ipyparallel

RUN useradd -ms /bin/bash jupyter

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

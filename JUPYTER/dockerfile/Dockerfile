# Usa la imagen base de Debian
FROM debian:latest

# Actualiza el índice de paquetes e instala las dependencias necesarias
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    apt-get clean

RUN apt-get install -y iproute2 iputils-ping vim

RUN pip install --break-system-packages ipyparallel

RUN useradd -ms /bin/bash jupyter

# Para montar desde otro contenedor en la misma red default:
#   mount -t nfs4 <nfs-server-ip>: <directorio_donde_montar>
# En NFSv4 el directorio que pongas commo fsid=0 sera virtualmente el directorio root.
# Entonces si quieres montarlo tienes que montar directamente el root

# Utilizar una imagen base adecuada, en este caso, Debian
FROM debian:latest

# Actualizar el sistema e instalar nfs-kernel-server
RUN apt-get update && apt-get install -y nfs-kernel-server

# Install ping in case connection check is needed later with kubernetes
RUN apt install -y iputils-ping

# Crear el directorio que se compartirá
RUN mkdir -p /nfs_share

# Definir el volumen para compartir
VOLUME /nfs_share

# Copiar el archivo de configuración exports
RUN echo "/nfs_share *(rw,sync,no_subtree_check,no_root_squash,fsid=0)" > /etc/exports

# Exponer el puerto NFS
EXPOSE 2049 

# Comando para iniciar el servicio NFS
# CMD ["sh", "-c", "rpcbind && rpc.nfsd && exportfs -rav && rpc.mountd  && tail -f /dev/null"]
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["./usr/local/bin/docker-entrypoint.sh"]
# Para montar desde otro contenedor en la misma red default:
#   mount -t nfs4 <nfs-server-ip>: <directorio_donde_montar>
# En NFSv4 el directorio que pongas commo fsid=0 sera virtualmente el directorio root.
# Entonces si quieres montarlo tienes que montar directamente el root

FROM debian:latest

ARG SHARED_DIR=/nfs_share

# Install packages needed for launching NFS server
RUN apt-get update && apt-get install -y nfs-kernel-server

# Crear el directorio que se compartirá
RUN mkdir -p ${SHARED_DIR}

# Define volume to share
VOLUME ${SHARED_DIR}
RUN echo "${SHARED_DIR} *(rw,sync,no_subtree_check,no_root_squash,fsid=0)" > /etc/exports

# Expose NFS port
EXPOSE 2049 

# Install ping in case connection check is needed later with kubernetes
RUN apt-get update && apt-get install -y iputils-ping

# Comando para iniciar el servicio NFS
# CMD ["sh", "-c", "rpcbind && rpc.nfsd && exportfs -rav && rpc.mountd  && tail -f /dev/null"]
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["./usr/local/bin/docker-entrypoint.sh"]
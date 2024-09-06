ARG BASE_IMAGE_TAG=latest

FROM debian-slurm:${BASE_IMAGE_TAG}

ENV MYSQL_VER=0.8.32-1
ENV DEBIAN_FRONTEND=noninteractive

ENV MYSQL_ADDRESS=127.0.0.1
ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_SLURM_PASSWORD=password

RUN apt-get update && apt-get install -y mysql-client

# Instalamos los paquetes específicos del SlurmDBD Node (https://slurm.schedmd.com/quickstart_admin.html#debinstall)
RUN dpkg -i /tmp/slurm-smd_${SLURMVER}-1_amd64.deb && \
    dpkg -i /tmp/slurm-smd-slurmdbd_${SLURMVER}-1_amd64.deb

COPY slurmdbd.conf /etc/slurm/slurmdbd.conf
RUN touch /var/run/slurmdbd.pid
RUN chmod 600 /etc/slurm/slurmdbd.conf /var/run/slurmdbd.pid && \
    chown slurm: /etc/slurm/slurmdbd.conf /var/run/slurmdbd.pid

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["./usr/local/bin/docker-entrypoint.sh"]
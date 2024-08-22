ARG BASE_IMAGE_TAG=latest

FROM debian-slurm:${BASE_IMAGE_TAG}

ENV MYSQL_VER=0.8.32-1
ENV DEBIAN_FRONTEND=noninteractive

# Instalamos mysql-server (https://dev.mysql.com/doc/refman/8.4/en/linux-installation-apt-repo.html)
RUN wget -P /tmp https://dev.mysql.com/get/mysql-apt-config_${MYSQL_VER}_all.deb
RUN DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/mysql-apt-config_${MYSQL_VER}_all.deb
RUN apt-get update && apt-get install -y mysql-server

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
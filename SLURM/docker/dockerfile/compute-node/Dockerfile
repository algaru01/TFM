ARG BASE_IMAGE_TAG=latest

FROM debian-slurm:${BASE_IMAGE_TAG}

ENV SLURMD_HOST=linux-hn
ENV SLURMDBD_PORT=6817

# Instalamos los paquetes específicos del Head Node
RUN dpkg -i /tmp/slurm-smd_${SLURMVER}-1_amd64.deb && \
    dpkg -i /tmp/slurm-smd-slurmd_${SLURMVER}-1_amd64.deb && \
    dpkg -i /tmp/slurm-smd-client_${SLURMVER}-1_amd64.deb

# Comprobamos que se crean correctamente los archivos y directorios especificados en slurm.conf así como otros archivos de estado
RUN mkdir -p        /var/spool/slurmd /var/log/slurm /var/run/slurmd && \
    chown slurm:    /var/spool/slurmd /var/log/slurm /var/run/slurmd && \
    chmod 755       /var/spool/slurmd /var/log/slurm /var/run/slurmd

RUN touch           /var/log/slurm/slurmd.log /var/log/slurm/jobcomp.log /var/run/slurmd/slurmd.pid && \
    chown slurm:    /var/log/slurm/slurmd.log /var/log/slurm/jobcomp.log /var/run/slurmd/slurmd.pid && \
    chmod 755       /var/log/slurm/slurmd.log /var/log/slurm/jobcomp.log /var/run/slurmd/slurmd.pid

COPY cgroup.conf /etc/slurm/cgroup.conf

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["./usr/local/bin/docker-entrypoint.sh"]
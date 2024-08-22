ARG BASE_IMAGE_TAG=latest

FROM debian-slurm:${BASE_IMAGE_TAG}

# Instalamos los paquetes específicos del Head Node
RUN dpkg -i /tmp/slurm-smd_${SLURMVER}-1_amd64.deb && \
    dpkg -i /tmp/slurm-smd-slurmctld_${SLURMVER}-1_amd64.deb && \
    dpkg -i /tmp/slurm-smd-client_${SLURMVER}-1_amd64.deb

# Comprobamos que se crean correctamente los archivos y directorios especificados en slurm.conf así como otros archivos de estado
RUN mkdir -p        /var/spool/slurmctld /var/log/slurm /var/run/slurm && \
    chown slurm:    /var/spool/slurmctld /var/log/slurm /var/run/slurm && \
    chmod 755       /var/spool/slurmctld /var/log/slurm /var/run/slurm

RUN touch           /var/log/slurm/slurmctld.log /var/log/slurm/jobcomp.log /var/run/slurm/slurmctld.pid && \
    chown slurm:    /var/log/slurm/slurmctld.log /var/log/slurm/jobcomp.log /var/run/slurm/slurmctld.pid && \
    chmod 755       /var/log/slurm/slurmctld.log /var/log/slurm/jobcomp.log /var/run/slurm/slurmctld.pid

RUN touch           /var/spool/slurmctld/assoc_usage /var/spool/slurmctld/last_config_lite /var/spool/slurmctld/node_state /var/spool/slurmctld/job_state /var/spool/slurmctld/resv_state /var/spool/slurmctld/trigger_state && \
    chown slurm:    /var/spool/slurmctld/assoc_usage /var/spool/slurmctld/last_config_lite /var/spool/slurmctld/node_state /var/spool/slurmctld/job_state /var/spool/slurmctld/resv_state /var/spool/slurmctld/trigger_state && \
    chmod 755       /var/spool/slurmctld/assoc_usage /var/spool/slurmctld/last_config_lite /var/spool/slurmctld/node_state /var/spool/slurmctld/job_state /var/spool/slurmctld/resv_state /var/spool/slurmctld/trigger_state

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["./usr/local/bin/docker-entrypoint.sh"]
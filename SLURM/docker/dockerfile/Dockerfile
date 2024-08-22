FROM debian:latest

ENV MUNGEUSER=1001
ENV SLURMUSER=1002
ENV SLURMVER=23.11.6
ENV MYSQL_VER=0.8.32-1

# Install gosu for permissions de-escalation
RUN apt-get update && apt-get install -y gosu

# Install tools for debugging
RUN apt-get update && apt-get install -y procps vim net-tools hostname iputils-ping dnsutils

# Install tools for mounting NFS
RUN apt-get update && apt-get install -y nfs-common

RUN apt-get update && apt-get install -y \
    openssh-server \
    openssh-client

RUN mkdir /var/run/sshd

# 1. INSTALACIÓN DE MURGE

# Crear grupo y usuario para MUNGE
RUN groupadd -g $MUNGEUSER munge && \
    useradd -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge -s /sbin/nologin munge

# Instalamos de Munge
RUN apt-get update && apt-get install -y munge libmunge-dev

# Comprobamos que los permisos son correctos
RUN mkdir munge: /run/munge && \
    chown munge: /run/munge

RUN chown -R munge: /etc/munge/ /var/log/munge/ && \
    chmod 0700 /etc/munge/ /var/log/munge/

# Creamos la clave /etc/munge/munge.key como usuario munge en caso de que no se creara automáticamente
RUN gosu munge /usr/sbin/mungekey --force --verbose

# 2. INSTALACIÓN DE SLURM

# Crear grupo y usuario para Slurm
RUN groupadd -g $SLURMUSER slurm && \
    useradd -m -c "Slurm workload manager" -d /var/lib/slurm -u $SLURMUSER -g slurm -s /bin/bash slurm

# 2.1 Slurm Plugins
# Instalamos paquetes necesarios para el plugin task/cgroup
RUN apt-get update && apt-get install -y hwloc bpfcc-tools dbus

# Instalamos mysql-dev-libraries para el plugin accounting_storage/as_mysql
RUN apt-get update && apt-get install -y lsb-release gnupg
RUN wget -P /tmp https://dev.mysql.com/get/mysql-apt-config_${MYSQL_VER}_all.deb
RUN DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/mysql-apt-config_${MYSQL_VER}_all.deb
RUN apt-get update && apt-get install -y libmariadb-dev-compat libmariadb-dev

# Instalamos OpenMPI
RUN apt-get update && apt-get install -y openmpi-bin libopenmpi-dev

# 2.2. Slurm
RUN apt-get update && apt-get install -y  \
        wget            \
        build-essential \
        fakeroot        \      
        devscripts

# Para hacer uso de mk-build-deps de manera no interactiva, debemos usar la opción --tools para instalar los paquetes con apt-get y así usar su opción de asumir 'yes' 
RUN wget "https://download.schedmd.com/slurm/slurm-${SLURMVER}.tar.bz2" -O /tmp/slurm-${SLURMVER}.tar.bz2 &&  \ 
    tar -xaf /tmp/slurm-${SLURMVER}.tar.bz2 -C /tmp &&                                   \
    cd /tmp/slurm-${SLURMVER} &&                                                 \
    mk-build-deps --install debian/control --tool='apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes' debian/control && \
    debuild -b -uc -us

COPY slurm.conf /etc/slurm/slurm.conf
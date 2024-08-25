FROM debian:latest

# Install gosu for permissions de-escalation
RUN apt-get update && apt-get install -y gosu

# Install tools for mounting NFS
RUN apt-get update && apt-get install -y nfs-common

# Install tools for SSH
RUN apt-get update && apt-get install -y \
    openssh-server \
    openssh-client 

RUN mkdir /var/run/sshd

# Install python
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip

# Install ipyparallel
RUN pip install --break-system-packages ipyparallel

# Install possibly necessary python libs
COPY requirements.txt /tmp/requirements.txt
RUN pip install --break-system-packages -r /tmp/requirements.txt

# Set up for Jupyter
RUN useradd -ms /bin/bash jupyter
RUN mkdir -p /home/jupyter/.ipython/profile_default/security && \
    chown -R jupyter:jupyter /home/jupyter

# Set ENV for shared config files directory
ENV IPCONTROLLER_JSON_DIR="/mnt/shared_storage"

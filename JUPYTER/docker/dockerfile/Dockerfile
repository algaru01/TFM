FROM debian:latest

RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    apt-get clean

# Install tools for debugging
RUN apt-get install -y iproute2 iputils-ping vim procps curl telnet

# Install ipyparallel
RUN pip install --break-system-packages ipyparallel

# Install possibly necessary python lib
COPY requirements.txt /tmp/requirements.txt
RUN pip install --break-system-packages -r /tmp/requirements.txt

# Set up for Jupyter
RUN useradd -ms /bin/bash jupyter
USER jupyter
RUN mkdir -p /home/jupyter/.ipython/profile_default/security

USER root

FROM debian:latest

RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    apt-get clean

RUN apt-get install -y iproute2 iputils-ping vim procps

RUN pip install --break-system-packages ipyparallel

RUN useradd -ms /bin/bash jupyter

USER jupyter

RUN mkdir -p /home/jupyter/.ipython/profile_default/security

USER root

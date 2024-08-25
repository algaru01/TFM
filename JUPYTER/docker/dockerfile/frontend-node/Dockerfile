# Use the previously created image
FROM debian-ipython:latest

# Install jupyter
RUN pip install --break-system-packages jupyter

# Install jupyterhub and libraries needed
RUN apt-get update && apt install -y npm
RUN pip install --break-system-packages jupyterhub notebook \
    && npm install -g configurable-http-proxy

# Copy config file for IPControler and JupyterHub
ENV CONFIG_DIR=/home/jupyter/config
RUN gosu jupyter mkdir -p ${CONFIG_DIR}
COPY ipcontroller_config.py ${CONFIG_DIR}/ipcontroller_config.py
COPY jupyterhub_config.py ${CONFIG_DIR}/jupyterhub_config.py

WORKDIR /home/jupyter

# Expose the port for accesing Jupyter Notebook
EXPOSE 8000

# Install tools for debugging. Uncomment if needed.
# RUN apt-get update && apt-get install -y iproute2 iputils-ping vim procps curl telnet

COPY docker-entrypoint.sh /tmp/docker-entrypoint.sh
ENTRYPOINT ["sh", "/tmp/docker-entrypoint.sh"]

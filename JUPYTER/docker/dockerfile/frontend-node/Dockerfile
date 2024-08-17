# Use the previously created image
FROM debian-ipython:latest

RUN pip install --break-system-packages jupyter

# Copy config file for IPControler
COPY ipcontroller_config.py /home/jupyter/config/ipcontroller_config.py

# Expose the port for accesing Jupyter Notebook
EXPOSE 8888

# Install tools for debugging. Uncomment if needed.
# RUN apt-get update && apt-get install -y iproute2 iputils-ping vim procps curl telnet

COPY docker-entrypoint.sh /tmp/docker-entrypoint.sh
ENTRYPOINT ["sh", "/tmp/docker-entrypoint.sh"]

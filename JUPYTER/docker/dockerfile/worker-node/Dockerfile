# Use the previously created image
FROM debian-ipython:latest

# Copy the config file for IPEngine
COPY ipengine_config.py /home/jupyter/config/ipengine_config.py

# Install tools for debugging. Uncomment if needed.
# RUN apt-get update && apt-get install -y iproute2 iputils-ping vim procps curl telnet

COPY docker-entrypoint.sh /tmp/docker-entrypoint.sh
ENTRYPOINT ["sh", "/tmp/docker-entrypoint.sh"]
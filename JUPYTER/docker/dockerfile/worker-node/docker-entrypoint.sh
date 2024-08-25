#!/bin/bash

log() {

  echo "---> $1"
}

log_error() {

  echo "ERROR: $1"
}

log "Starting the Secure Shell daemon (sshd)  ..."
    /usr/sbin/sshd
    if ! pgrep -f sshd > /dev/null; then
        log_error "SSHD process is not running."
        exit 1
    fi

log "Starting the Ipython Engine  ..."
    exec gosu jupyter ipengine --IPEngine.extra_config_file=${CONFIG_DIR}/ipengine_config.py > /home/jupyter/nohup_ipengine.out 2>&1 &
    if ! pgrep -f ipengine > /dev/null; then
        log_error "IPENGINE process is not running. Showing stdout and stderr"
        cat /home/jupyter/nohup_ipcontroller.out 
        exit 1
    fi

log "Worker successfully started"  

while :; do sleep 2073600 & wait; done
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

log "Starting the JupyterHub  ..."
    exec jupyterhub -f ${CONFIG_DIR}/jupyterhub_config.py > /home/jupyter/nohup_jupyter.out 2>&1 &

    sleep 3
    if ! pgrep -f jupyterhub > /dev/null; then
        log_error "JUPYTERHUB process is not running. Showing stdout and stderr"
        cat /home/jupyter/nohup_ipcontroller.out 
        exit 1
    fi


log "Starting the Ipython Controller  ..."
    exec gosu jupyter ipcontroller --IPController.extra_config_file=${CONFIG_DIR}/ipcontroller_config.py > /home/jupyter/nohup_ipcontroller.out 2>&1 &

    sleep 3
    if ! pgrep -f ipcontroller > /dev/null; then
        log_error "IPCONTROLLER process is not running. Showing stdout and stderr"
        cat /home/jupyter/nohup_ipcontroller.out 
        exit 1
    fi

log "Making ipcontroller-cient.json readable by all users ..."
    json_client_file="${IPCONTROLLER_JSON_DIR}/ipcontroller-client.json"
    while [ ! -e "$json_client_file" ]; do
        echo "Waiting until $json_client_file exists..."
        sleep 1 
    done
    chmod a+r $json_client_file

log "Frontend successfully started"   

while :; do sleep 2073600 & wait; done
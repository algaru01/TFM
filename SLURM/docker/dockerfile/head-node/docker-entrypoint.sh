#!/usr/bin/env bash

log() {

  echo "---> $1"
}

log_error() {

  echo "ERROR: $1"
}

#echo "172.17.0.3    linux1" >> /etc/hosts

log "Starting the Secure Shell daemon (sshd)  ..."
    /usr/sbin/sshd
    if ! pgrep -f sshd > /dev/null; then
        log_error "SSHD process is not running."
        exit 1
    fi

log "Starting the MUNGE Authentication service (munged) ..."
    gosu munge /etc/init.d/munge start
    if ! pgrep -f munge > /dev/null; then
        log_error "MUNGE process is not running."
        exit 1
    fi

log "Waiting for db node (${SLURMDBD_HOST}) to become active before starting slurmd..."
    until 2>/dev/null >/dev/tcp/${SLURMDBD_HOST}/${SLURMDBD_PORT}
    do
        echo "-- db node (${SLURMDBD_HOST}) is not available.  Sleeping ..."
        sleep 2
    done
    echo "-- db node (${SLURMDBD_HOST}) is now active ..."

log "Starting the Slurm Node Daemon (slurmd) ..."
    exec gosu slurm /usr/sbin/slurmctld -Dvvv
    if ! pgrep -f sshd > /dev/null; then
        log_error "SLURMCTLD process is not running."
        exit 1
    fi

log "Frontend successfully started"  

while :; do sleep 2073600 & wait; done
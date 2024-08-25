#!/usr/bin/env bash

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

log "Starting the MUNGE Authentication service (munged) ..."
    gosu munge /etc/init.d/munge start
    if ! pgrep -f munge > /dev/null; then
        log_error "MUNGE process is not running."
        exit 1
    fi

log "Starting the mysql-server daemon (mysqld) ..."
    mysqld --user=mysql &

    echo -n "Waiting for MySQL to start..."
        while ! mysqladmin ping -h localhost; do
            echo -n "."
            sleep 1
        done

log "MySQL started successfully!"

log "Configurating mysql for slurm use ..."
mysql -e "create user 'slurm'@'localhost' identified by 'password';"
mysql -e "grant all on slurm_acct_db.* TO 'slurm'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"
mysql -e "CREATE DATABASE slurm_acct_db;"

log "Starting the slurm database daemon (slurmdbd) ..."
    gosu slurm slurmdbd -Dvvv
    if ! pgrep -f slurmdbd > /dev/null; then
        log_error "SLURMDBD process is not running."
        exit 1
    fi

log "DB node successfully started"  

while :; do sleep 2073600 & wait; done
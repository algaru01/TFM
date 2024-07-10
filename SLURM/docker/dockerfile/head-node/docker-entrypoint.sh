#!/usr/bin/env bash

#echo "172.17.0.3    linux1" >> /etc/hosts

echo "---> Starting the Secure Shell daemon (sshd)  ..."
    /usr/sbin/sshd

echo "---> Starting the MUNGE Authentication service (munged) ..."
    sudo -u munge /etc/init.d/munge start

echo "---> Waiting for db node (linux-db) to become active before starting slurmd..."
    until 2>/dev/null >/dev/tcp/linux-db/6819
    do
        echo "-- db node (linux-db) is not available.  Sleeping ..."
        sleep 2
    done

echo "---> Starting the Slurm Node Daemon (slurmd) ..."
    exec sudo -u slurm /usr/sbin/slurmctld -Dvvv
    # tail -f /dev/null

bash
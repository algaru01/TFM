#!/usr/bin/env bash

#echo "172.17.0.3    linux1" >> /etc/hosts

echo "---> Starting the Secure Shell daemon (sshd)  ..."
    /usr/sbin/sshd

echo "---> Starting the MUNGE Authentication service (munged) ..."
    sudo -u munge /etc/init.d/munge start

echo "---> Starting the Slurm Node Daemon (slurmd) ..."
    exec sudo -u slurm /usr/sbin/slurmctld -Dvvv

bash
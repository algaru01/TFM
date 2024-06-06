#!/usr/bin/env bash

#echo "172.17.0.2    linux-hn" >> /etc/hosts

echo "---> Starting the Secure Shell daemon (sshd)  ..."
    /usr/sbin/sshd

echo "---> Starting the MUNGE Authentication service (munged) ..."
    sudo -u munge /etc/init.d/munge start

echo "---> Waiting for head node (linux-hn) to become active before starting slurmd..."
    until 2>/dev/null >/dev/tcp/linux-hn/6817
    do
        echo "-- head node (linux-hn) is not available.  Sleeping ..."
        sleep 2
    done
echo "-- head node (linux-hn) is now active ..."

echo "---> Starting the Slurm Node Daemon (slurmd) ..."
    exec /usr/sbin/slurmd -Dvvv

bash
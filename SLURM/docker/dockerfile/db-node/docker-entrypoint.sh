#!/usr/bin/env bash

echo "---> Starting the Secure Shell daemon (sshd)  ..."
    /usr/sbin/sshd

echo "---> Starting the MUNGE Authentication service (munged) ..."
    sudo -u munge /etc/init.d/munge start

echo "---> Starting the mysql-server daemon (mysqld) ..."
    mysqld --user=mysql &

echo -n "Waiting for MySQL to start..."
    while ! mysqladmin ping -h localhost; do
        echo -n "."
        sleep 1
    done
echo "MySQL started successfully!"

echo "--> Configurating mysql for slurm use ..."
mysql -e "create user 'slurm'@'localhost' identified by 'password';"
mysql -e "grant all on slurm_acct_db.* TO 'slurm'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"
mysql -e "CREATE DATABASE slurm_acct_db;"

echo "--> Starting the slurm database daemon (slurmdbd) ..."
    sudo -u slurm slurmdbd -Dvvv

bash
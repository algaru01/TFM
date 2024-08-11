#!/bin/bash

echo "---> Starting the Secure Shell daemon (sshd)  ..."
    /usr/sbin/sshd

echo "---> Starting the Ipython Engine  ..."
    sudo -u jupyter ipengine --IPEngine.extra_config_file=/home/jupyter/config/ipengine_config.py
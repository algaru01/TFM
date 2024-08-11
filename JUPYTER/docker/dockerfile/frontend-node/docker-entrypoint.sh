#!/bin/bash

echo "---> Starting the Secure Shell daemon (sshd)  ..."
    /usr/sbin/sshd

echo "---> Starting the Jupyter Notebook  ..."
    sudo -u jupyter nohup jupyter notebook --ip=0.0.0.0 --port=8888 > nohup_jupyter.out &

echo "---> Starting the Ipython Controller  ..."
    sudo -u jupyter ipcontroller --IPController.extra_config_file=/home/jupyter/config/ipcontroller_config.py
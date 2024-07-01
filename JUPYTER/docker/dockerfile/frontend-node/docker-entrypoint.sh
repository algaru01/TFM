#!/bin/bash

echo "---> Starting the Jupyter Notebook  ..."
    nohup jupyter notebook --ip=0.0.0.0 --port=8888 > nohup_jupyter.out &

echo "---> Starting the Ipython Controller  ..."
    ipcontroller --IPController.extra_config_file=/home/jupyter/config/ipcontroller_config.py
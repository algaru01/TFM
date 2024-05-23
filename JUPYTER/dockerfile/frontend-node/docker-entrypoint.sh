#!/bin/bash

echo "---> Starting the Jupyter Notebook  ..."
    nohup jupyter notebook --ip=0.0.0.0 --port=8888 > nohup_jupyter.out &

echo "---> Starting the Ipython Controller  ..."
    nohup ipcontroller --reuse > nohup_ipcontroller.out &

while true; do
    sleep 3600  # Espera 1 hora antes de volver a verificar
done
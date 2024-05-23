#!/bin/bash

echo "---> Starting the Ipython Engine  ..."
    nohup ipengine > nohup_ipcontroller.out &

while true; do
    sleep 3600  # Espera 1 hora antes de volver a verificar
done
# Jupyter IPython Cluster in Kubernetes

This folder contains Kubernetes manifests to create a *Multi-container Jupyter IPython Cluster*.

## `frontend.yaml`
It creates a *frontend* `pod` that will run a `debian-ipython-fn` image created in `docker/`. It mounts a volume from a `ConfigMap` in `/home/jupyter/config` to automate the options for the ipcontroller and its `ipcontroller-engine.json` and `ipcontroller-client.json`. It also mounts a volume shared with *workers*  for the `ipcontroller-engine.json` and `ipcontroller-client.json`.

Lastly it puts a `Service` in front of this `pod` so *workers* can communicate with it at the ports specified in the `ipcontroller_config.py`.
It also creates an Ingress to access its Jupyter Server.

## `workers.yaml`
It creates a `Deployment` that will generate a specified number of *worker* replicas using the `debian-ipython-wn` image created in the `docker/` directory. Aditionally, it mounts a `ConfigMap` in `/home/jupyter/config` for the `ipengine_config.py`. It also mounts a volume shared with the *frontend*  for the `ipcontroller-engine.json` and `ipcontroller-client.json`.

## `volume.yaml`
It will create a `PersistentVolume` and a `PersistentVolumeClaim` for a volume shared between *frontend* adn *workers*. This way `ipcontroller-engine.json` and `ipcontroller-client.json` will be created and stored there (as they must be the same for each node).

## `cm-ipythonconf.yaml`
It contains all configuraton files needed for automatization: a `ipcontroller_config.py` and a `ipengine_config.py` that will generate both `ipcontroller-engine.json` and `ipcontroller-client.json` in a shared volume between *frontend* and *workers*.

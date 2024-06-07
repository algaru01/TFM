# Jupyter IPython Cluster in Kubernetes

This folder contains Kubernetes manifests to create a *Multi-container Jupyter IPython Cluster*.

## `frontend.yaml`
It creates a *frontend* `pod` that will run a `debian-ipython-fn` image created in `docker/`. It mounts a volume from a `ConfigMap` in `/home/jupyter/.ipython/profile_default/security/` to automate the `ipcontroller-engine.json`.

Lastly it puts a `Service` in front of this `pod` so *workers* can communicate with it at the ports specified in the `ipcontroller-engine.json`.

## `workers.yaml`
It creates a `Deployment` that will generate a specified number of *worker* replicas using the `debian-ipython-wn` image created in the `docker/` directory. dditionally, it mounts a `ConfigMap` in `/home/jupyter/.ipython/profile_default/security/` and sets up a `Service` for the same reasons specified in the *frontend*.

## `configmap-fn.yaml` and `configmap-wn.yaml`
They contains all configuraton files needed for automatization. As you can see they have mostly the same content.
This happens because this file must be the same for all the nodes. However, the `interface` section, which contains the *frontend* IP, cannot be known until creation of the `pod`. As a temporary solution, we used a `ConfigMap` for the *frontend* with its hostname (as it can resolve it), and another one for the *workers* using the *frontend* `Service` domain name.

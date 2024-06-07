# Slurm Cluster in Kubernetes

This folder contains Kubernetes manifests to create a *Multi-container Slurm Cluster*.

## `frontend.yaml`
It creates a `head-node` `pod` that will run a `debian-slurm-hn` image created in `docker/`. It mounts a volume from a `ConfigMap` in `/etc/slurm/` to automate the `slurm.conf`.
This way, we are actually overwriting the configuration file we used in the image building. 
Even though this might seem a bit tricky, it allows us to create all Kubernetes objects easily while also enabling isolated testing of images.

Lastly it puts a `Service` in front of this `pod` so `compute-nodes` can communicate with it at the port specified.

## `workers.yaml`
It creates a `StatefulSet` that will generate a specified number of `compute-node` replicas using the `debian-slurm-cn` image created in the `docker/` directory. Additionally, it mounts a `ConfigMap` in `/etc/slurm/` and sets up a `Service` for the same reasons specified in the *frontend*.

## `configmap.yaml`
It contains all configuraton files needed for automatization. 


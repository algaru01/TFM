# Jupyter IPython Cluster in Kubernetes

This folder contains Kubernetes manifests to create a *Multi-container Jupyter IPython Cluster*.

## `frontend.yaml`
It creates a *frontend* `pod`.
* If local NFS is enabled, it creates a `initContainer` that will wait until *nfsd* is ready.
* It creates a `initContainer` that changes the owner of the shared directory between nodes for the JSON file.
* If there are any user, it creates a `init container` that will change the permissions of their home directories.
* Then, it will that will run a `debian-ipython-fn` image created in `docker/`. It mounts three volumes:
    * **NFS**. Shared NFS `volume` from `nfs.yaml` for each user home directory and the JSON files shared beetwen *frontend* and *workers*.
    * **JUPYTER Configuration Files**. `ConfigMap` in `/home/jupyter/config` to automate the options for the ipcontroller and its `ipcontroller-engine.json` and `ipcontroller-client.json`.
    * **User Configuration Files**. Configuration files for users in cluster from a `confgimap` in `users.yaml`.

Lastly it puts a `Service` in front of this `pod` so *workers* can communicate with it at the ports specified in the `ipcontroller_config.py`, and another `Service` for SSH access.
It also creates an `Ingress` to access its Jupyter Server.

## `workers.yaml`
It creates a *worker *`Deployment`.
* If local NFS is enabled, it creates a `initContainer` that will wait until *nfsd* is ready.
* It then creates a `initContainer` that will wait until *frontend* in has created `ipcontroller-engine.json` file in a shared volume. This means IPController is ready.
* Latly, it will create a specified number of *worker* replicas using the `debian-ipython-wn` image created in the `docker/` directory. It mounts three volumes:
    * **NFS**. Shared NFS `volume` from `nfs.yaml` for each user home directory and the JSON files shared beetwen *frontend* and *workers*.
    * **JUPYTER Configuration Files**. `ConfigMap` in `/home/jupyter/config` to automate the options for the ipengine.
    * **User Configuration Files**. Configuration files for users in cluster from a `confgimap` in `users.yaml`.

## `nfs.yaml`
It creates one `PersistentVolume` and `PersistentVolumeClaim` per user specified as Helm value for the NFS.

* In case the use of local NFS is enabled, it will create a pod that mounts the NFS server used by other nodes.
    * It creates firstly a `initContainer` that creates each user and jupyter directory.
    * Then it run a `nfs-server` image created in `docker/`.
    * Lastly, it will wait 30 seconds before terminating. This is done to ensure that no other pod using this NFS server finishes before it, as they would get stuck in a terminating state.
    * This pod requires some special capabilities, which may actually pose a small security risk. However, this is still a good way for testing.

* In case any other NFS server is provided, it must already have a directory created for each user as `<NFS_dir>/user_home_dir_<number>` and another for jupyter as `<NFS_dir>/jupyter_shared` .

## `config.yaml`
It contains all configuraton files needed for automatization: a `ipcontroller_config.py` and a `ipengine_config.py` that will generate both `ipcontroller-engine.json` and `ipcontroller-client.json` in a shared volume between *frontend* and *workers*.

## `users.yaml`
It contains all the configuration files required to keep track of the cluster users.
* **passwd**. File with users in system. It will automatically add users specified as Helm values.
* **group**. File with groups in system. It will automatically add user groups specified as Helm values.
* **shadow**. File with users passwords. It will automatically add users passwords specified as Helm values.
* **gshadow** File with groups passwords. It will automatically add user groups specified as Helm values but with no password.

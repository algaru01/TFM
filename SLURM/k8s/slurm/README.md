# Templates for Slurm Cluster in Kubernetes
A directory of templates that, when combined with values, will generate valid Kubernetes manifest files.

## `_helpers.tpl`
It defines some templates to be used in other YAML files. For example to automize nodes hostname or FQDN.

## `frontend.yaml`
It creates a `head-node` `pod`.
* If local NFS is enabled, it creates a `initContainer` that will wait until *nfsd* is ready.
* If DB is enabled, it creates a `initContainer` that will wait until *slurmdbd* is ready.
* If there are any user, it creates a `init container` that will change the permissions of their home directories.
* Then, it will run a `debian-slurm-hn` image created in `docker/`. This mounts three volumes:
    * **Init Script**. Init script mounted from a `configmap` in `startup.yaml` to execute required init daemons.
    * **NFS**. Shared NFS `volume` from `volume.yaml` for each user home directory.
    * **SLURM Configuration Files**. Configuration files for SLURM from a `confgimap` in `slurm-config
    .yaml`.
    * **User Configuration Files**. Configuration files for users in cluster from a `confgimap` in `users.yaml`.

Lastly it puts a `Service` in front of this `pod` so *workers* can communicate with it at the port specified, and another service for SSH connections from outside the Kubernetes cluster.

## `workers.yaml`
It creates a `compute-node` `StatefulSet`.
* It first creates a `initContainer` that will wait until *slurmctld* in *frontend* is ready.
* Then, it creates a specified number of `compute-node` replicas using the `debian-slurm-cn` image created in the `docker/` directory. This mounts three volumes:
    * **Init Script**. Init script mounted from a `configmap` in `startup.yaml` to execute required init daemons.
    * **NFS**. Shared NFS `volume` from `volume.yaml` for each user home directory.
    * **SLURM Configuration Files**. Configuration files for SLURM from a `confgimap` in `slurm-config
    .yaml`.
    * **User Configuration Files**. Configuration files for user in cluster from a `confgimap` in `users.yaml`.

Lastly it puts a `Service` in front of this `pod` so *frontend* can communicate with this `StatefulSet` at the port specified.

## `db.yaml`
It creates a `db-node` `pod`.
* It first creates a `initContainer` that will copy files from a `configmap volume` to an `emptyDir Volume` and then it will set up permissions so only slurm user can access those files. The reaseon for this is because *slurmdbd*, unlike other *Slurm daemons*, force you to set this permissions up, and `configmp volumes` do not allow you to change this. So we must use an intermediary directory. This way we mount two volumes here.
    * **Configuration Files**. Configuration files from a `confgimap` in `slurm-config
    .yaml`.
    * **Empty Dir**. `emptyDir` used as intermediary for configuration files.
* Then, it creates a container using the `debian-slurm-db` image created in the `docker/` directory. It mounts only one volume:
    * **Empty Dir**. `emptyDir` used as intermediary for configuration files and filled previously in the `initContainer`.
It also uses a `secret` form `slurm-config
.yaml` for `mysql` password.

Finally, we use again a `Service` for communication with the rest of *Slurm daemons*.

## `slurm-config.yaml`
It contains all the configuraton files required for automatization:
* **slurm.conf**. General configuration of Slurm. Used in all nodes.
* **slurmdb.conf**. If DB is enabled, configuration for *slurmdbd*. Used in *db-node*.
* **cgroup.conf**. Configuration of *cgroup plugin*. Used in *compute-nodes*.

## `users.yaml`
It contains all the configuration files required to keep track of the cluster users.
* **passwd**. File with users in system. It will automatically add users specified as Helm values.
* **group**. File with groups in system. It will automatically add user groups specified as Helm values.
* **shadow**. File with users passwords. It will automatically add users passwords specified as Helm values.
* **gshadow** File with groups passwords. It will automatically add user groups specified as Helm values but with no password.

## `startup.yaml`
Startup scripts for all nodes.

## `nfs.yaml`
It creates one `PersistentVolume` and `PersistentVolumeClaim` per user specified as Helm value for the NFS.

* In case the use of local NFS is enabled, it will create a pod that mounts the NFS server used by other nodes.
    * It creates firstly a `initContainer` that creates each user directory.
    * Then it run a `nfs-server` image created in `docker/`.
    * Lastly, it will wait 30 seconds before terminating. This is done to ensure that no other pod using this NFS server finishes before it, as they would get stuck in a terminating state.
    * This pod requires some special capabilities, which may actually pose a small security risk. However, this is still a good way for testing.

* In case any other NFS server is provided, it must already have a directory created for each user as `<NFS_dir>/user_home_dir_<number>`.


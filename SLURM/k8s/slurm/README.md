# Templates for Slurm Cluster in Kubernetes
A directory of templates that, when combined with values, will generate valid Kubernetes manifest files.

## `_helpers.tpl`
It defines some templates to be used in other YAML files. For example to automize nodes hostname or FQDN.

## `frontend.yaml`
It creates a `head-node` `pod`.
* It first creats a `initContainer` that will wait until *slurmdbd* is ready.
* Then, it will run a `debian-slurm-hn` image created in `docker/`. This mounts three volumes:
    * **Init Script**. Init script mounted from a `configmap` in `startup.yaml` to execute needed init daemons.
    * **NFS**. Shared NFS `volume` from `volume.yaml` for *workers* job results.
    * **Configuration Files**. Configuration files from a `confgimap` in `config.yaml`.

Lastly it puts a `Service` in front of this `pod` so *workers* can communicate with it at the port specified.

## `workers.yaml`
It creates a `compute-node` `StatefulSet`.
* It first creates a `initContainer` that will wait until *slurmctld* is ready.
* Then, it creates a specified number of `compute-node` replicas using the `debian-slurm-cn` image created in the `docker/` directory. This mounts three volumes:
    * **Init Script**. Init script mounted from a `configmap` in `startup.yaml` to execute needed init daemons.
    * **NFS**. Shared NFS `volume` from `volume.yaml` for *workers* job results.
    * **Configuration Files**. Configuration files from a `confgimap` in `config.yaml`.

Lastly it puts a `Service` in front of this `pod` so *frontend* can communicate with this `StatefulSet` at the port specified.

## `db.yaml`
It creates a `db-node` `pod`.
* It first creates a `initContainer` that will copy files from a `configmap volume` to an `emptyDir Volume` and then it will set up permissions so only slurm user can access those files. The reaseon for this is because *slurmdbd*, unlike other *Slurm daemons*, force you to set this permissions up, and `configmp volumes` do not allow you to change this. So we must use an intermediary directory. This way we mount two volumes here.
    * **Configuration Files**. Configuration files from a `confgimap` in `config.yaml`.
    * **Empty Dir**. `emptyDir` used as intermediary for configuration files.
* Then, it creates a container using the `debian-slurm-db` image created in the `docker/` directory. It mounts only one volume:
    * **Empty Dir**. `emptyDir` used as intermediary for configuration files and filled previously in the `initContainer`.
It also uses a `secret` form `config.yaml` for `mysql` password.

Finally, we use again a `Service` for communication with the rest of *Slurm daemons*.

## `config.yaml`
It contains all configuraton files needed for automatization:
* **slurm.conf**. General configuration of Slurm. Used in all nodes.
* **slurmdb.conf**. Configuration for *slurmdbd*. Used in *db-node*.
* **cgroup.conf**. Configuration of *cgroup plugin*. Used in *compute-nodes*.

## `startup.yaml`
Startup scripts for all nodes.

## `volume.yaml`
It creates the `PersistentVolume` and `PersistentVolumeClaim` for the NFS volume.



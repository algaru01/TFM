# Slurm Cluster in Docker

This folder contains Docker images to create a *Multi-container Slurm Cluster*.

---

Specifically, this will create three types of containers:
* *Head Node*. Node running the *slurmctld* daemon that manages jobs.
* *Compute Node*. Node running the *slurmd* daemon that executes jobs.
* *Database Node*. Node running the *slurmdbd* daemon for accounting jobs.
* *NFS Node*. Node running a NFS server in case you need it.

## Folder Structure
### `dockerfile/`
Contains all the Dockerfiles and files needed to create the Docker Images.

Firstly, it creates a base Debian Slurm image with all common tools like `munge` or `slurm` and other debugging programs.

From this base image, it then creates a specific image for each type of node except for the NFS.

The NFS node creates its own image from a simple Debian one.

### `Makefile`
Makefile given to automate image building and testing.

### `docker-compose.yaml`
It creates a `head-node`, two `compute-node`, one `database-node` and one `nfs-node`.
It also creates its own network and a volume for the shared

## Building Images
A Makefile has been made to make it easier to build and test images.


Build the images locally:
```console
make build
```
---
You can test the images now.

Start the containers:
```console
make run
```

And attach to the containers where `xx` is either `hn=head_node` or `cn=compute_node`.:
```console
make attach_xx
```

**ATTENTION**: In order to use the cluster, nodes must be able to resolve each other hostnames. Take into account that, by default, docker containers cannot do this. So you either add it to the `/etc/hosts` in the `docker-entrypoint.sh`, or do it manually.

## Docker-Compose

### Start the Cluster

Start the cluster by using `docker-compose`:
```console
docker-compose up
```

### Accessing to the Cluster

Access each node in the Cluster with:
```console
docker exec -it <node> bash
```

### Removing the Cluster

Remove the Cluster created by using `docker-compose`:

```console
docker-compose down
```

## Test
You can test everything is working by accessing the head node.

There you can check if slurm is correctly installed and print the *Compute Nodes*.
```
scontrol --version
scontrol show nodes
sinfo
```

Finally, you can try launching a job.
Create a script with the following.
``` prueba.sh
#!/bin/bash
#SBATCH --job-name=test_job
#SBATCH --output=/mnt/shared/test_job_output.txt
#SBATCH --ntasks=2
#SBATCH --time=00:01:00

srun hostname
```
This will make two nodes print its hostname and store it in a shared volume.

Launch it with:
```
sbatch <script>
```

You can check the queues.
```
squeue
```

You can test the accounting with:
```
sacct
```

## Troubleshooting

* `head-node` hostname must be the same specified in `SlurmctldHost` in the `slurm.conf`.
* `compute-nodes` hostname must be the same specified in `NodeName` in the `slurm.conf`.
* Ports exposed for each node must be the same specified in `SlurmctldPort`(`head-node`) and `SlurmdPort`(`compute-node`).
* Number of `compute-node` replicas must be in the limit specified in `NodeName` in the `slurm.conf`.
* As we mentioned, nodes must be able to resolve to each other hostnames.

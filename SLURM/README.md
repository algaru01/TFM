# Slurm Cluster in Docker

Multi-container Slurm Cluster builded with Docker.

## Containers
This will create two containers:
* *Head Node*. Node running the *slurmctld* daemon that manages works.
* *Compute Node*. Node running the *slurmd* daemon that executes works.

## Building Images
A Makefile has been made to make it easier to build and test images.


Build the images locally:
```console
make build
```

You can test the images now.

Start the containers:
```console
make run
```

And attach to the containers where `xx` is either `hn=head_node` or `cn=compute_node`.:
```console
make attach_xx
```

ATTENTION: Take into account that, by default, docker containers cannot resolve to other containers hostnames. So you either uncomment the line that adds it to the `/etc/hosts` in the `docker-entrypoint.sh`, or add it manually.

## Starting the Cluster

Start the cluster by using `docker-compose`:
```console
docker-compose up
```

## Accessing to the Cluster

Access each node in the Cluster with:
```console
docker exec -it <node> bash
```

## Removing the Cluster

Remove the Cluster created by using `docker-compose`:

```console
docker-compose down
```

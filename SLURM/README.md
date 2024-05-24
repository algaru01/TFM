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
#SBATCH --output=test_job_output.txt
#SBATCH --ntasks=1
#SBATCH --time=00:01:00

echo "Hola, mundo!"
```
And launch it.
```
sbatch <script>
```

You can check the queues.
```
squeue
```

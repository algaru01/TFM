# Test Slurm-Cluster
Even if a more elaborated testing must be made, we have created a `Makefile` that will do a little testing over the Slurm Cluster created.
For information about how to launch the cluster by using Helm go to `SLURM/k8s/README.md`.

This `Makefile` will show information about the Cluster created and then send a job to print the hostname of each node.
By now, only one node will carry out given task (the first node). Then it will make such node to print the output.

## Troubleshooting
Make sure `$FRONTEND_NAME` is the hostname of the head node and `$WORKERS_NAME` the hostname of the compute node (without its replica ID).

# Test Slurm-Cluster
Even if a more elaborated testing must be made, we have created a `Makefile` that will do a little testing over the Slurm Cluster created.
For information about how to launch the cluster by using Helm go to `SLURM/k8s/README.md`.

This `Makefile` will show information about the Cluster created and then send a job to print the hostname of each node.

## Troubleshooting
> Make sure `$POD_FRONTEND` is the name of the head node pod and `$WORKERS_NAME` the name of the compute node pod (without its replica ID).
> Make sure `$COTNAINER_FRONTEND` is the name of the main container of the Frontend pod.

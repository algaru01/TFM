# Test Jupyter-Cluster
Even if a more elaborated testing must be made, we have created a `Makefile` that will do a little testing over the Jupyter Cluster created.
For information about how to launch the cluster by using Helm go to `SLURM/k8s/README.md`.

This `Makefile` will copy a test file to the *frontend* which will ask for the *workers* nodes ids and it will makes them print a simple "Hello, World".
It then will make a HTTP GET call to the Jupyter Server.

## Troubleshooting
Make sure `$FRONTEND_NAME` is the hostname of the head node.
# Slurm Cluster in Kubernetes with Helm
This directory contains a Helm Chart to create a *Multi-container Slurm Cluster*.

## Folder Structure
### `templates/`
A directory of templates that, when combined with values, will generate valid Kubernetes manifest files.

### `values.yaml`
The default configuration values for this chart.

### `values.schema.json`
A JSON Schema for imposing a structure on the `values.yaml` file.

### `Chart.yaml`
A YAML file containing information about the chart.

### `Makefile`
Makefile given to automate chart installation and uninstallation.

## Create Chart
You can use given `Makefile` to create the chart.

This will uninstall any Chart called slurm-cluster (if installed) and install a new one:
```
make
```

You can also do it manually:
```
helm install slurm-cluster slurm/
helm uninstall slurm-cluster
```

## Debug
You can debug your resulting manifiestos by using the given `Makefile`:
```
make template
```



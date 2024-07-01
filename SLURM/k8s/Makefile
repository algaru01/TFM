CHART_NAME=slurm-cluster

all: uninstall install

install:
	helm install ${CHART_NAME} slurm/

uninstall:
	- helm uninstall ${CHART_NAME}

template:
	helm template --debug slurm/
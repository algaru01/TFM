CHART_NAME=jupyter-cluster

all: uninstall install

install:
	helm install ${CHART_NAME} jupyter/

uninstall:
	- helm uninstall ${CHART_NAME}

template:
	helm template --debug jupyter/
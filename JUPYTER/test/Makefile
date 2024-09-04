RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[0;33m
BLUE=\033[0;34m
NC=\033[0m # No Color

FRONTEND_NAME=jupyter-cluster-frontend

INGRESS_IP=$(shell kubectl get ingress jupyter-cluster-frontend-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
TOKEN=$(shell kubectl logs ${FRONTEND_NAME} | grep -o 'token=[a-f0-9]*' | head -n 1 | awk -F= '{print $$2}')

test:
	@echo "${GREEN}>> Test a Python file that prints workers IDs and makes them exec a "Hello World".${NC}"
	kubectl cp test.py ${FRONTEND_NAME}:/home/test/test.py
	kubectl exec -i ${FRONTEND_NAME} -- python3 /home/test/test.py

	@echo "${GREEN}>> Get headers of the Jupyter Notebook Server ${NC}"
	curl -I "http://$(INGRESS_IP)"
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[0;33m
BLUE=\033[0;34m
NC=\033[0m # No Color

FRONTEND_NAME=slurm-cluster-frontend
WORKERS_NAME=slurm-cluster-lin


test:
	@echo "${GREEN}>> Show  information  about Slurm nodes and partitions.${NC}"
	kubectl exec ${FRONTEND_NAME} -- sinfo

	@echo "${GREEN}>> Make nodes print a simple hello world.${NC}"
	kubectl exec ${FRONTEND_NAME} -- sh -c 'printf "#!/bin/bash\n#SBATCH --job-name=test_job\n#SBATCH --output=test_job_output.txt\n#SBATCH --ntasks=1\n#SBATCH --time=00:01:00\n\n hostname \n" > prueba.sh'
	kubectl exec ${FRONTEND_NAME} -- sbatch prueba.sh
	kubectl exec ${FRONTEND_NAME} -- squeue

	@echo "${GREEN}>> Print result in a node.${NC}"
	kubectl exec ${WORKERS_NAME}-0 -- cat test_job_output.txt

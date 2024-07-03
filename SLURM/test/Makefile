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

	@echo "${GREEN}>> Make 3 nodes print a simple hello world.${NC}"
	kubectl exec ${FRONTEND_NAME} -- sh -c 'printf "#!/bin/bash\n#SBATCH --job-name=test_job\n#SBATCH --output=/shared-vol/test_job.out\n#SBATCH --ntasks=3\n#SBATCH --time=00:01:00\n\n srun hostname \n" > prueba.sh'
	kubectl exec ${FRONTEND_NAME} -- sbatch prueba.sh
	kubectl exec ${FRONTEND_NAME} -- squeue

	@echo "${GREEN}>> Print result.${NC}"
	sleep 1
	kubectl exec ${FRONTEND_NAME} -- cat /shared-vol/test_job.out

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
	sleep 3
	kubectl exec ${FRONTEND_NAME} -- cat /shared-vol/test_job.out

	@echo "${BLUE}>> Make 3 nodes print a simple hello world with MPI ${NC}"
	kubectl cp ./hello.c default/${FRONTEND_NAME}:/shared-vol
	kubectl exec ${FRONTEND_NAME} -- mpicc /shared-vol/hello.c -o /shared-vol/hello
	kubectl exec ${FRONTEND_NAME} -- sh -c 'printf "#!/bin/bash\n#SBATCH --job-name=test_job_mpi\n#SBATCH --output=/shared-vol/test_job_mpi.out\n#SBATCH --ntasks=3\n#SBATCH --time=00:01:00\n\n srun /shared-vol/hello \n" > prueba_mpi.sh'
	kubectl exec ${FRONTEND_NAME} -- sbatch prueba_mpi.sh
	@echo "${BLUE}>> Print result.${NC}"
	sleep 3
	kubectl exec ${FRONTEND_NAME} -- cat /shared-vol/test_job_mpi.out

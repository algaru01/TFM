RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[0;33m
BLUE=\033[0;34m
NC=\033[0m # No Color

POD_FRONTEND=slurm-cluster-frontend
CONTAINER_FRONTEND=-c frontend
WORKERS_NAME=slurm-cluster-lin


test:
	@echo "${GREEN}>> Show  information  about Slurm nodes and partitions.${NC}"
	kubectl exec ${POD_FRONTEND} ${CONTAINER_FRONTEND} -- sinfo

	@echo "${GREEN}>> Make 3 nodes print its hostname.${NC}"
	kubectl exec ${POD_FRONTEND} ${CONTAINER_FRONTEND} -- sh -c 'printf "#!/bin/bash\n#SBATCH --job-name=test_job\n#SBATCH --output=/home/test/test_job.out\n#SBATCH --ntasks=3 --ntasks-per-node=1\n#SBATCH --time=00:01:00\n\n srun hostname \n" > prueba.sh'
	kubectl exec ${POD_FRONTEND} ${CONTAINER_FRONTEND} -- sbatch prueba.sh
	kubectl exec ${POD_FRONTEND} ${CONTAINER_FRONTEND} -- squeue

	@echo "${GREEN}>> Print result.${NC}"
	sleep 3
	kubectl exec ${POD_FRONTEND} ${CONTAINER_FRONTEND} -- cat /home/test/test_job.out

	@echo "${BLUE}>> Make 3 nodes print a simple hello world with MPI ${NC}"
	kubectl cp ./hello.c default/${POD_FRONTEND}:/home/test ${CONTAINER_FRONTEND}
	kubectl exec ${POD_FRONTEND} ${CONTAINER_FRONTEND} -- mpicc /home/test/hello.c -o /home/test/hello
	kubectl exec ${POD_FRONTEND} ${CONTAINER_FRONTEND} -- sh -c 'printf "#!/bin/bash\n#SBATCH --job-name=test_job_mpi\n#SBATCH --output=/home/test/test_job_mpi.out\n#SBATCH --ntasks=3 --ntasks-per-node=1\n#SBATCH --time=00:01:00\n\n srun /home/test/hello \n" > prueba_mpi.sh'
	kubectl exec ${POD_FRONTEND} ${CONTAINER_FRONTEND} -- sbatch prueba_mpi.sh
	@echo "${BLUE}>> Print result.${NC}"
	sleep 5
	kubectl exec ${POD_FRONTEND} ${CONTAINER_FRONTEND} -- cat /home/test/test_job_mpi.out

HEAD-NODE_IMG=debian-slurm-hn
HEAD-NODE_IMG-TAG=latest

COMPUTE-NODE_IMG=debian-slurm-cn
COMPUTE-NODE_IMG-TAG=latest

DB-NODE_IMG=debian-slurm-db
DB-NODE_IMG-TAG=latest

HN_CONT_NAME=slurm-head-node
CN_CONT_NAME=slurm-compute-node
DB_CONT_NAME=slurm-db-node

all: build start


build:
	docker build -t debian-slurm:latest ./dockerfile
	docker build -t ${HEAD-NODE_IMG}:${HEAD-NODE_IMG-TAG} ./dockerfile/head-node
	docker build -t ${COMPUTE-NODE_IMG}:${COMPUTE-NODE_IMG-TAG} ./dockerfile/compute-node
	docker build -t ${DB-NODE_IMG}:${DB-NODE_IMG-TAG} ./dockerfile/db-node

run:
	docker run -d -ti --name ${HN_CONT_NAME} --hostname linux0  ${HEAD-NODE_IMG}:${HEAD-NODE_IMG-TAG}
	docker run -d -ti --name ${CN_CONT_NAME} --hostname linux1  ${COMPUTE-NODE_IMG}:${COMPUTE-NODE_IMG-TAG}
	docker run -d -ti --name ${DB_CONT_NAME} --hostname linuxdb  ${DB-NODE_IMG}:${DB-NODE_IMG-TAG}

attach_hn:
	docker attach ${HN_CONT_NAME}

attach_cn:
	docker attach ${CN_CONT_NAME}

attach_db:
	docker attach ${DB_CONT_NAME}

remove:
	docker stop ${HN_CONT_NAME} ${CN_CONT_NAME} ${DB_CONT_NAME}
	docker rm 	${HN_CONT_NAME} ${CN_CONT_NAME} ${DB_CONT_NAME}

push:
	docker tag 	${HEAD-NODE_IMG}:${HEAD-NODE_IMG-TAG}  agalrui/${HEAD-NODE_IMG}:${HEAD-NODE_IMG-TAG}
	docker push agalrui/${HEAD-NODE_IMG}:${HEAD-NODE_IMG-TAG}

	docker tag 	${COMPUTE-NODE_IMG}:${COMPUTE-NODE_IMG-TAG}  agalrui/${COMPUTE-NODE_IMG}:${COMPUTE-NODE_IMG-TAG}
	docker push agalrui/${COMPUTE-NODE_IMG}:${COMPUTE-NODE_IMG-TAG}

	docker tag 	${DB-NODE_IMG}:${DB-NODE_IMG-TAG}  agalrui/${DB-NODE_IMG}:${DB-NODE_IMG-TAG}
	docker push agalrui/${DB-NODE_IMG}:${DB-NODE_IMG-TAG}
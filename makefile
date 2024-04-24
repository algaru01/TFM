HEAD-NODE_IMG=debian-slurm-hn
HEAD-NODE_IMG-TAG=latest

COMPUTE-NODE_IMG=debian-slurm-cn
COMPUTE-NODE_IMG-TAG=latest

HN_CONT_NAME=slurm-head-node
CN_CONT_NAME=slurm-compute-node

all: build start


build:
	docker build -t debian-slurm:latest ./dockerfile
	docker build -t ${HEAD-NODE_IMG}:${HEAD-NODE_IMG-TAG} ./dockerfile/head-node
	docker build -t ${COMPUTE-NODE_IMG}:${COMPUTE-NODE_IMG-TAG} ./dockerfile/compute-node

run:
	docker run -d -ti --name ${HN_CONT_NAME} --hostname linux0  ${HEAD-NODE_IMG}:${HEAD-NODE_IMG-TAG}
	docker run -d -ti --name ${CN_CONT_NAME} --hostname linux1  ${COMPUTE-NODE_IMG}:${COMPUTE-NODE_IMG-TAG}

attach_hn:
	docker attach ${HN_CONT_NAME}

attach_cn:
	docker attach ${CN_CONT_NAME}

remove:
	docker stop ${HN_CONT_NAME} ${CN_CONT_NAME}
	docker rm 	${HN_CONT_NAME} ${CN_CONT_NAME}
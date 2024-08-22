HEAD-NODE_IMG=debian-slurm-hn
HEAD-NODE_IMG-TAG=latest

COMPUTE-NODE_IMG=debian-slurm-cn
COMPUTE-NODE_IMG-TAG=latest

DB-NODE_IMG=debian-slurm-db
DB-NODE_IMG-TAG=latest

NFS_IMG=nfs-server
NFS_IMG_TAG=latest

HN_CONT_NAME  = slurm-head-node
CN_CONT_NAME  = slurm-compute-node
DB_CONT_NAME  = slurm-db-node
NFS_CONT_NAME = nfs-server-node

NFS_VOL_NAME = mynfs

#### BENCHMARK ####



###################

all: build start

build_benchmark:
	docker build -t debian-slurm:benchmark ./dockerfile/benchmark

	docker build --build-arg BASE_IMAGE_TAG=benchmark -t ${HEAD-NODE_IMG}:benchmark	./dockerfile/head-node &
	docker build --build-arg BASE_IMAGE_TAG=benchmark -t ${COMPUTE-NODE_IMG}:benchmark	./dockerfile/compute-node &
	docker build --build-arg BASE_IMAGE_TAG=benchmark -t ${DB-NODE_IMG}:benchmark	./dockerfile/db-node

build:
	docker build -t ${NFS_IMG}:${NFS_IMG_TAG} 					./dockerfile/nfs &

	docker build -t debian-slurm:latest 						./dockerfile
	docker build -t ${HEAD-NODE_IMG}:${HEAD-NODE_IMG-TAG} 		./dockerfile/head-node &
	docker build -t ${COMPUTE-NODE_IMG}:${COMPUTE-NODE_IMG-TAG} ./dockerfile/compute-node &
	docker build -t ${DB-NODE_IMG}:${DB-NODE_IMG-TAG} 			./dockerfile/db-node &

run:
	docker volume create --driver local --opt type=nfs --opt o=addr=172.17.0.2,vers=4,soft --opt device=: ${NFS_VOL_NAME}
	docker run -d -ti --name ${NFS_CONT_NAME} --hostname linuxnfs  --privileged ${NFS_IMG}:${NFS_IMG-TAG}

	docker run -d -ti --name ${HN_CONT_NAME}  --hostname linux0    -v ${NFS_VOL_NAME}:/mnt/shared_storage ${HEAD-NODE_IMG}:${HEAD-NODE_IMG-TAG}
	docker run -d -ti --name ${CN_CONT_NAME}  --hostname linux1    -v ${NFS_VOL_NAME}:/mnt/shared_storage ${COMPUTE-NODE_IMG}:${COMPUTE-NODE_IMG-TAG}
	docker run -d -ti --name ${DB_CONT_NAME}  --hostname linuxdb										  ${DB-NODE_IMG}:${DB-NODE_IMG-TAG}

attach_hn:
	docker attach ${HN_CONT_NAME}

attach_cn:
	docker attach ${CN_CONT_NAME}

attach_db:
	docker attach ${DB_CONT_NAME}

attach_nfs:
	docker attach ${NFS_CONT_NAME}

remove:
	docker stop ${HN_CONT_NAME} ${CN_CONT_NAME} ${DB_CONT_NAME} ${NFS_CONT_NAME}
	docker rm 	${HN_CONT_NAME} ${CN_CONT_NAME} ${DB_CONT_NAME} ${NFS_CONT_NAME}

	docker volume rm ${NFS_VOL_NAME}
	

push:
	docker tag 	${HEAD-NODE_IMG}:${HEAD-NODE_IMG-TAG}  agalrui/${HEAD-NODE_IMG}:${HEAD-NODE_IMG-TAG}
	docker push agalrui/${HEAD-NODE_IMG}:${HEAD-NODE_IMG-TAG} &

	docker tag 	${COMPUTE-NODE_IMG}:${COMPUTE-NODE_IMG-TAG}  agalrui/${COMPUTE-NODE_IMG}:${COMPUTE-NODE_IMG-TAG}
	docker push agalrui/${COMPUTE-NODE_IMG}:${COMPUTE-NODE_IMG-TAG} &

	docker tag 	${DB-NODE_IMG}:${DB-NODE_IMG-TAG}  agalrui/${DB-NODE_IMG}:${DB-NODE_IMG-TAG}
	docker push agalrui/${DB-NODE_IMG}:${DB-NODE_IMG-TAG} &

	docker tag 	${NFS_IMG}:${NFS_IMG_TAG}  agalrui/${NFS_IMG}:${NFS_IMG_TAG}
	docker push agalrui/${NFS_IMG}:${NFS_IMG_TAG} &

push_benchmark:
	docker tag 	${HEAD-NODE_IMG}:benchmark  agalrui/${HEAD-NODE_IMG}:benchmark
	docker push agalrui/${HEAD-NODE_IMG}:benchmark &

	docker tag 	${COMPUTE-NODE_IMG}:benchmark  agalrui/${COMPUTE-NODE_IMG}:benchmark
	docker push agalrui/${COMPUTE-NODE_IMG}:benchmark &

	docker tag 	${DB-NODE_IMG}:benchmark  agalrui/${DB-NODE_IMG}:benchmark
	docker push agalrui/${DB-NODE_IMG}:benchmark &
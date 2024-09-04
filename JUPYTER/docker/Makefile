FRONTEND_IMG	 = debian-ipython-fn
FRONTEND_IMG-TAG = latest

WORKER_IMG		= debian-ipython-wn
WORKER_IMG-TAG 	= latest

NFS_IMG     = nfs-server
NFS_IMG-TAG = latest

FN_CONT_NAME  = jupyter-frontend
WN_CONT_NAME  = jupyter-worker
NFS_CONT_NAME = nfs-server-node

WORKERS_NUM = 2

NFS_VOL_NAME = mynfs

#ARGS
WORKER_ID=

all: build start


build:
	docker build -t ${NFS_IMG}:${NFS_IMG-TAG} 					./dockerfile/nfs &

	docker build -t debian-ipython:latest 				./dockerfile
	docker build -t ${FRONTEND_IMG}:${FRONTEND_IMG-TAG} ./dockerfile/frontend-node &
	docker build -t ${WORKER_IMG}:${WORKER_IMG-TAG} 	./dockerfile/worker-node   &

run:
	docker volume create --driver local --opt type=nfs --opt o=addr=172.17.0.2,vers=4,soft --opt device=: ${NFS_VOL_NAME}
	docker run -d -ti --rm --name ${NFS_CONT_NAME} --hostname linuxnfs  --privileged ${NFS_IMG}:${NFS_IMG-TAG}

	docker run -p 8888:8888 -d -ti  --name ${FN_CONT_NAME} --hostname linux0 -v ${NFS_VOL_NAME}:/mnt/shared_storage ${FRONTEND_IMG}:${FRONTEND_IMG-TAG}
	
	@for i in $$(seq 1 $(WORKERS_NUM)); do \
        docker run -d -ti  --name $(WN_CONT_NAME)$$i --hostname linux$$i -v ${NFS_VOL_NAME}:/mnt/shared_storage $(WORKER_IMG):$(WORKER_IMG-TAG); \
    done

exec_fn:
	docker exec -ti ${FN_CONT_NAME} bash

#make exec_wn WORKER_ID={1...WORKER_NUM}
exec_wn:
	@if [ $(WORKER_ID) -gt $(WORKERS_NUM) ] || [ $(WORKER_ID) -lt 1 ]; then \
		echo "Error. Invalid WORKER_ID. Must be a number between 1 and $(WORKERS_NUM)"; \
		exit 1; \
	fi

	docker exec -ti ${WN_CONT_NAME}$(WORKER_ID) bash

attach_fn:
	docker attach ${FN_CONT_NAME}

attach_wn:
	docker attach ${WN_CONT_NAME}

attach_nfs:
	docker attach ${NFS_CONT_NAME}

remove:
	- docker stop ${FN_CONT_NAME}
	- docker rm   ${FN_CONT_NAME}
	
	@for i in $$(seq 1 $(WORKERS_NUM)); do \
        docker stop $(WN_CONT_NAME)$$i || true; \
		docker rm 	${WN_CONT_NAME}$$1 || true; \
    done

	docker stop ${NFS_CONT_NAME}
	docker rm   ${NFS_CONT_NAME}

	docker volume rm ${NFS_VOL_NAME}

push:
	docker tag 	${FRONTEND_IMG}:${FRONTEND_IMG-TAG}  agalrui/${FRONTEND_IMG}:${FRONTEND_IMG-TAG}
	docker push agalrui/${FRONTEND_IMG}:${FRONTEND_IMG-TAG} &

	docker tag 	${WORKER_IMG}:${WORKER_IMG-TAG}  agalrui/${WORKER_IMG}:${WORKER_IMG-TAG}
	docker push agalrui/${WORKER_IMG}:${WORKER_IMG-TAG} &

	docker tag 	${NFS_IMG}:${NFS_IMG-TAG}  agalrui/${NFS_IMG}:${NFS_IMG-TAG}
	docker push agalrui/${NFS_IMG}:${NFS_IMG-TAG} &
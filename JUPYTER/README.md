# Jupyter IPython cluster in Docker

Multi-container IPython Cluster builded with Docker.

## Containers
This will create two types of containers:
* *Frontend Node*. Node running the *ipcontroller* that manages works.
* *Worker Node*. Several nodes running the *ipengine* that executes works.

## Building Images
A Makefile has been made to make it easier to build and test images.


Build the images locally:
```console
make build
```

You can test the images now.

Start the containers:
```console
make run
```

And attach to the containers where `xx` is either `fn=frontend_node` or `wn=worker_node`. If using `wn` you must specify WORKER_ID={1...WORKER_NUM}:
```console
make attach_xx
```

## Starting the Cluster

Start the cluster by using `docker-compose`:
```console
docker-compose up
```

### Accessing to the Cluster

Access each node in the Cluster with:
```console
docker exec -it <node> bash
```

## Getting Started
For now, we must do some configuration manually.

### Frontend
Get the IP.
```
ip -f inet -br addr show dev eth0
```

Execute the *controller*.
```
nohup ipcontroller --ip=x.x.x.x &
```

Copy the genersted file to your host machine.
```
docker cp <container_name>:/root/.ipython/profile_default/security/ipcontroller-engine.json ipcontroller-engine.json
```

### Workers
Create needed directories.
```
docker exec -it <name_container> mkdir -p /root/.ipython/profile_default/security/
```

Copy the generated *frontend* file to each node
``` ln:false
docker cp ipcontroller-engine.json <name_container>:/root/.ipython/profile_default/security/ipcontroller-engine.json
```

Enter in each container and execute the *engine*.
```
docker exec -it <container_name> bash
	$ nohup ipengine --file=/root/.ipython/profile_default/security/ipcontroller-engine.json &
```

## Test
Once everyhting is setted up, you can test it by running `python` in the *frontend node*.
This is an example for 2 *worker nodes*.
```
jupyter@linux0:~$ python3
Python 3.11.2 (main, Mar 13 2023, 12:18:29) [GCC 12.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import ipyparallel as ipp
>>> c=ipp.Client('/home/jupyter/.ipython/profile_default/security/ipcontroller-client.json')
>>> c.ids
[0, 1]
>>> c[:].apply_sync(lambda: "Hello, World")
['Hello, World', 'Hello, World']
```
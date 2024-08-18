# Jupyter IPython cluster in Docker

This folder contains Docker images to create a *Multi-container Jupyter IPython Cluster*.

---

Specifically, this will create two types of containers:
* *Frontend Node*. Node running the *ipcontroller* that manages works, and the Jupyter Server for user access.
* *Worker Node*. Several nodes running the *ipengine* that executes works.
* *NFS Node*. Node running a NFS server in case you need it.

## Folder Structure
### `dockerfile/`
Contains all the Dockerfiles and files needed to create the Docker Images.

Firstly, it creates a base Debian Ipython image with all common tools like `jupyter`, `ipyparallel` and other debugging programs.

From this base image, it then creates a specific image for each type of node, i.e. one for the *Frontend Node* and one for the *Worker Node*.

The NFS node creates its own image from a simple Debian one.

### `Makefile`
Makefile given to automate image building and testing.

### `docker-compose.yaml`
It creates a `head-node` with two `compute-node` and a `nfs-node`.

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

Lastly, you can push the images to your docker repository:

```
make push
```

## Docker-Compose
### Start the Cluster
Start the cluster by using `docker-compose`:
```console
docker-compose up
```

### Access the Cluster

Access each node in the Cluster with:
```console
docker exec -it <node> bash
```

### Remove the Cluster
Remove the Cluster created with:
```console
docker-compose down
```

## Test

### Getting Started
In case you are only testing the docker images either by using the Makefile or with the `docker-compose.yaml`, you have to do some configuration manually.

#### Frontend

Check if `ipcontroller` has been launched correctly.

In case it did not, launch it manually by getting the IP and executing.
```
ip -f inet -br addr show dev eth0
```

```
nohup ipcontroller --ip=x.x.x.x &
```

Finally, copy the generated file to your host machine.
```
docker cp <container_name>:/root/.ipython/profile_default/security/ipcontroller-engine.json ipcontroller-engine.json
```

#### Workers
Here, `ipcontroller` most likely failed, as *Workers* do not have the `ipcontroller-engine.json` file. So launch it manually.

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

### Example
Once everyhting is setted up, you can test it by running `python3` in the *frontend node*.
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
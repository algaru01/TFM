# Jupyter IPython cluster in Docker

Multi-container IPython Cluster in Kubernetes.

## Architecture

### Pods
This will create two types of pods:
* *Frontend Node*. Node running the *ipcontroller* that manages works. Created with a *pod*.
* *Worker Node*. Several nodes running the *ipengine* that executes works. Created with a *deployment*

### Service
*Frontend* will be behind a *Service*, this way *Workers* will have a static domain name to access it. This is needed mainly for configuration in `ipcontroller-engine.json`.

### Configmap
Two *Configmaps* are needed for configuration in `ipcontroller-engine.json`. They are mainly the same, the main difference is the domain name which will resolve to the *Frontend* IP. As we mentioned, *Workers* use a Service and *Frontend* uses its hostname.



## Docker Images
### Explanation
At first, we create a base image for both types of containers that will contain everything that is equally needed for *Frontend* and *Workers*. These are some tools like python, creation of the Jupyter user, or directories needed for configuration.

Lastly, starting from this base image, we specify each node in its particular Dockerfile.

### Build, test and push
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

### Docker compose
You can also used the prepared `docker-compose.yaml` to test everything.

Start the cluster:
```console
docker-compose up
```

Access each node in the Cluster with:
```console
docker exec -it <node> bash
```

### Getting Started
In case you are only testing the docker images either by using the Makefile or with the `docker-compose.yaml`, you have to do some configuration manually.

#### Frontend

Check if `ipcontroller` has been launched correctly.

In case it did not, launch it manually by getting the IP and executing.
Get the IP.
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

## Launch Cluster in Kubernetes
To launch the cluster in Kubernetes, apply the following YAMLs in this order.
```
kubectl apply -f configmap-fn.yaml
kubectl apply -f configmap-wn.yaml
kubectl apply -f service.yaml
kubectl apply -f frontend.yaml
kubectl apply -f deployment.yaml
```

Once everything is up, it should be ready to use. Except frontend's Notebook is still not available from the host.

## Test
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
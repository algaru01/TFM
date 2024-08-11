import ipyparallel as ipp

c = ipp.Client("/home/jupyter/jupyter_shared/ipcontroller-client.json")
print(c.ids)
print(c[:].apply_sync(lambda: "Hello, World"))

def identify():
    import os
    import socket

    return {"host": socket.gethostname(), "pid": os.getpid()}

print(c[:].apply_async(identify).get_dict())

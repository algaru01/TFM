import ipyparallel as ipp
c = ipp.Client("/home/jupyter/my-nfs/ipcontroller-client.json")
# c = ipp.Client()
print(c.ids)
print(c[:].apply_sync(lambda: "Hello, World"))

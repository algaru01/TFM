import os

ip_controller_json_dir = os.environ["IPCONTROLLER_JSON_DIR"]
# Configuration file for ipengine.

c = get_config()

c.IPEngine.url_file=ip_controller_json_dir+"/ipcontroller-engine.json"
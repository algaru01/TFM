#!/usr/bin/env bash

trap "stop; exit 0;" SIGTERM SIGINT

stop()
{

  log "SIGTERM caught, terminating NFS process(es)..."
  /usr/sbin/exportfs -uav
  /usr/sbin/rpc.nfsd 0
  pid1=`pidof rpc.nfsd`
  pid2=`pidof rpc.mountd`
  # For IPv6 bug:
  pid3=`pidof rpcbind`
  kill -TERM $pid1 $pid2 $pid3 > /dev/null 2>&1
  echo "Terminated."
  exit
}


log() {

  echo "---> $1"
}

log_error() {

  echo "ERROR: $1"
}



log "Displaying /etc/exports contents"
cat /etc/exports

log "Starting the rpcbind"
/sbin/rpcbind -w

log "Starting NFS in the background"
/usr/sbin/rpc.nfsd --debug 8 --no-udp --no-nfs-version 3
# comprobar que se lanza bien
log "Exporting File System"
if /usr/sbin/exportfs -rv; then
  /usr/sbin/exportfs
else
  log_error "Export validation failed, exiting"
  exit 1
fi

log "Starting Mountd in the background"
/usr/sbin/rpc.mountd --debug all --no-udp --no-nfs-version 2 --no-nfs-version 3
# --exports-file /etc/exports

# Check if NFS is now running by recording it's PID (if it's not running $pid will be null):
pid=`pidof rpc.mountd`

# If $pid is null, startup failed; log the fact and sleep for 2s
# We'll then automatically loop through and try again
if [ -z "$pid" ]; then
  log_error "Startup of NFS failed."
fi

log "Startup successful"

while :; do sleep 2073600 & wait; done
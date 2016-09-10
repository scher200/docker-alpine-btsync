#!/bin/bash

#set -x

# magically renumber the nobody user
sed -i "s|nobody:x:65534:65534:|nobody:x:$USERID:$GROUPID:|" /etc/passwd
sed -i "s|nobody:x:65534:|nobody:x:$GROUPID:|" /etc/group

# provide a nice btsync.conf if not yet there
if [ ! -f /config/btsync.conf ]; then
cat << EOF > "/config/btsync.conf"
{
  "storage_path" : "/config/.sync",
  "listening_port" : 55555,
  "use_upnp" : true,
  "webui" :
  {
    "listen" : "0.0.0.0:8888"
    ,"login" : "admin"
    ,"password" : "password"
  }
}
EOF
fi

mkdir -p /config/.sync

chown -R nobody:nobody /config

echo "Happy Randomized Key (for use in btsync.conf):"
Asecret=$(/opt/btsync/btsync --generate-secret) && echo "read-write:" && echo $Asecret && echo "read-only:" && /opt/btsync/btsync --get-ro-secret $Asecret && Asecret=""

# start btsync if it's not only for the keys
if [ ! -z "$KEYS_ONLY" ]; then
  if [ ! -z "$DEBUG" ]; then
    rm /config/btsync.log
    touch /config/btsync.log
    tail -f /config/btsync.log 1>&2 &
  fi
  echo "Starting BTSync .. OK"
  exec gosu nobody:nobody /opt/btsync/btsync --nodaemon --config /config/btsync.conf --log /config/btsync.log
fi

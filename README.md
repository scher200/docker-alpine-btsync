Alpine BitTorrent Sync
===============

Sync uses peer-to-peer technology to provide fast, private file sharing for teams and individuals. By skipping the cloud, transfers can be significantly faster because files take the shortest path between devices. Sync does not store your information on servers in the cloud, avoiding cloud privacy concerns.

# Usage

Docker-compose wize:
cd /home/**$USER**/
git clone https://github.com/scher200/docker-alpine-btsync ./btsync
cd ./btsync
docker-compose up -d

OR the normal way

    DATA_FOLDER=/path/to/data/folder/on/the/host
    WEBUI_PORT=[ port to access the webui on the host ]

    mkdir -p $DATA_FOLDER

    docker run -d --name Sync \
      -p 127.0.0.1:$WEBUI_PORT:8888 -p 55555 \
      -v $DATA_FOLDER:/mnt/sync \
      --restart on-failure \
      scher200/alpine-btsync

Go to localhost:$WEBUI_PORT in a web browser to access the webui.

#### LAN access

If you do not want to limit the access to the webui to localhost, run instead:

    docker run -d --name Sync \
      -p $WEBUI_PORT:8888 -p 55555 \
      -v $DATA_FOLDER:/sync \
      --restart on-failure \
      scher200/alpine-btsync

#### Extra directories

If you need to mount extra directories, mount them like /sync/**foldername**:

    docker run -d --name Sync \
      -p 127.0.0.1:$WEBUI_PORT:8888 -p 55555 \
      -v $DATA_FOLDER:/sync \
      -v $CONFIG_FOLDER_WITH_btsync_dot_conf_IN_IT:/config \
      -v <OTHER_DIR>:/sync/<DIR_NAME> \
      -v <OTHER_DIR2>:/sync/<DIR_NAME2> \
      -e DEBUG=1 \ # does a simple: tail -f config/btsync.log 
      --restart on-failure \
      scher200/alpine-btsync


#### Generate just some keys

If you need keys for your own config/btsync.conf, you can use this command:

    docker run --rm -e KEYS_ONLY=1 scher200/alpine-btsync


# Volume

* /sync - State files and Sync folders

# Ports

* 8888 - Webui
* 55555 - Listening port for Sync traffic

# Standard Webui Login
user: admin
password: password
(change them as you like in the generated btsync.conf)

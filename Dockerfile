# Alpine with glibc fixed in
FROM slintes/alpine-glibc
MAINTAINER scher200

# GET install tools
RUN apk --no-cache --update add \
    wget \ 
    bash \
    curl \
    tar \
    ca-certificates

# GET gosu and latest btsync
RUN apk --update add tar && \
    curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.4/gosu-amd64" && \
    chmod +x /usr/local/bin/gosu && \
    mkdir -p /opt/btsync && \
    curl -s -k -L "https://download-cdn.getsync.com/stable/linux-x64/BitTorrent-Sync_x64.tar.gz" | tar -xzf - -C /opt/btsync && \
    rm -rf /var/cache/apk/*

#ENV GOSU_VERSION 1.9
#RUN set -x \
#    && apk add --no-cache --virtual .gosu-deps \
#        dpkg \
#        gnupg \
#        openssl \
#    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
#    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
#    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
#    && export GNUPGHOME="$(mktemp -d)" \
#    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
#    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
#    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
#    && chmod +x /usr/local/bin/gosu \
#    && gosu nobody true \
#    && apk del .gosu-deps


# GET dumb-init
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.1/dumb-init_1.1.1_amd64
RUN chmod +x /usr/local/bin/dumb-init

# make it look good
COPY start.sh /start.sh
RUN chmod +x /start.sh

ENV USERID 1000
ENV GROUPID 1000

VOLUME /config
VOLUME /sync

WORKDIR /config

EXPOSE 8888 55555 55555/udp

ENTRYPOINT ["/usr/local/bin/dumb-init"]

CMD ["/start.sh"]

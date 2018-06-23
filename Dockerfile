FROM frolvlad/alpine-glibc
MAINTAINER jond <me@iamjon.net>

ENV DEB_URL=https://s3.amazonaws.com/bizmodeller/MyMediaForAlexa/Release+1.3.82.0/mymedia_1.3.82.0-1_amd64.deb
ENV DEB_PKG=mymedia.deb

RUN  adduser  -D -g '' mymedia

RUN \
    apk --no-cache add dpkg tar curl ffmpeg && \
    mkdir -p /tmp/dl && \
    cd /tmp/dl && \
    curl ${DEB_URL} --output /tmp/dl/mymedia.deb && \
    dpkg-deb -x /tmp/dl/mymedia.deb ./ && \
    mv opt / && \
    cd && rm -rf /tmp/dl && \
    apk --no-cache --purge del dpkg tar curl 

RUN \
    mkdir -p /library/itunes /library/watched /library/playlists

VOLUME [ "/library/itunes", "/library/music", "/library/playlists", "/home/mymedia" ]

EXPOSE 50250/tcp
EXPOSE 52051/tcp

USER "mymedia"
ENTRYPOINT [ "/opt/mymedia/MyMediaForAlexa" ]

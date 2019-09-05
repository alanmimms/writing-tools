FROM ubuntu:19.04

COPY calibre-3.44.0-x86_64.txz pandoc-2.7.2-1-amd64.deb /root/
COPY .fonts /root/.fonts
COPY pp /usr/bin/

RUN \
    apt-get update && \
    apt-get install -y python ca-certificates make mesa-utils \
            libfontconfig1 libxrender1 libxcomposite1

RUN \
    mkdir -p /opt/calibre && \
    tar xvf /root/calibre-3.44.0-x86_64.txz -C /opt/calibre && \
    rm -f /root/calibre-3.44.0-x86_64.txz && \
    /opt/calibre/calibre_postinstall

RUN \
    dpkg -i /root/pandoc-2.7.2-1-amd64.deb && \
    rm -f /root/pandoc-2.7.2-1-amd64.deb && \
    mkdir -p /data

ENV PATH /opt/calibre:$PATH
WORKDIR /data

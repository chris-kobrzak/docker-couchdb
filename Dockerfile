FROM couchdb:2

MAINTAINER Krzysztof Kobrzak <chris.kobrzak@gmail.com>

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive && \
  apt-get install -y -qq --no-install-recommends \
    netcat && \
  apt-get autoremove -y && \
  apt-get clean

COPY scripts /usr/local/bin
COPY etc/* /opt/couchdb/etc/local.d/

RUN \
  touch /opt/couchdb/lib/couchdb-not-inited && \
  chown -R couchdb:couchdb /usr/local/bin/* && \
  chmod -R +x /usr/local/bin/*

USER couchdb

# Expose our data, logs and configuration volumes
VOLUME ["/opt/couchdb/data", "/opt/couchdb/var/log", "/opt/couchdb/etc"]

ENTRYPOINT ["start_couchdb"]

CMD [""]

FROM couchdb:1

MAINTAINER Krzysztof Kobrzak <chris.kobrzak@gmail.com>

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive && \
  apt-get install -y -qq --no-install-recommends \
    netcat \
    pwgen && \
  apt-get autoremove -y && \
  apt-get clean

COPY scripts /usr/local/bin
COPY etc/* /usr/local/etc/couchdb/local.d/

RUN \
  touch /var/lib/couchdb/couchdb-not-inited && \
  chown -R couchdb:couchdb \
    /usr/local/bin/* \
    /usr/local/etc/couchdb \
    /usr/local/share/couchdb \
    /usr/local/share/doc \
    /var/lib/couchdb && \
  chmod -R 0770 \
    /usr/local/etc/couchdb \
    /usr/local/var/lib/couchdb \
    /usr/local/var/log/couchdb \
    /usr/local/var/run/couchdb && \
  chmod -R +x \
    /usr/local/bin/*

USER couchdb

# Expose our data, logs and configuration volumes
VOLUME ["/var/lib/couchdb", "/usr/local/var/log/couchdb", "/usr/local/etc/couchdb"]

ENTRYPOINT ["start_couchdb"]
CMD [""]

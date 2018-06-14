FROM couchdb:1

MAINTAINER Krzysztof Kobrzak <chris.kobrzak@gmail.com>

COPY scripts /usr/local/bin
COPY etc/* /usr/local/etc/couchdb/local.d/

# CouchDB dependencies, required utilities etc.
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive && \
  apt-get install -y -qq --no-install-recommends \
    netcat && \
  apt-get autoremove -y && \
  apt-get clean

RUN \
  touch /var/lib/couchdb/couchdb-not-inited && \
  chown -R couchdb:couchdb \
    /usr/local/bin/* \
    /usr/local/etc/couchdb \
    /usr/local/lib/couchdb \
    /usr/local/share/doc \
    /usr/local/var/lib/couchdb \
    /usr/local/var/log/couchdb \
    /usr/local/var/run/couchdb \
    /var/lib/couchdb && \
  chmod -R 0770 \
    /usr/local/etc/couchdb \
    /usr/local/var/lib/couchdb \
    /usr/local/var/log/couchdb \
    /usr/local/var/run/couchdb && \
  chmod -R +x \
    /usr/local/bin/*

RUN \
  sed -e 's/^bind_address = .*$/bind_address = 0.0.0.0/' -i /usr/local/etc/couchdb/default.ini

USER couchdb

# Expose our data, logs and configuration volumes
VOLUME ["/var/lib/couchdb", "/usr/local/var/log/couchdb", "/usr/local/etc/couchdb"]

ENTRYPOINT ["start_couchdb"]
CMD [""]

# CouchDB Dockerfile

A Dockerfile that produces a Docker image for [Apache CouchDB](http://couchdb.apache.org/).

## TL;DR

  - configured with CORS support,
  - runs everything as user `couchdb`,
  - uses CouchDB 1.7.1,
  - is based on the official `couchdb:1` Docker image.

## CouchDB version

The `master` branch currently hosts CouchDB 1.7.1.

## Usage

### Build the image

To create the image, execute the following command:

```
$ docker build -t kobretti/couchdb-cors .
```

### Create Docker container from image

To run the image and bind to host port 5984:

```
$ docker run -d --name couchdb -p 5984:5984 kobretti/couchdb-cors
```

#### Admin user with random password

If you set the `COUCHDB_USERNAME` environment variable via the `-e` flag to the command above,
a new user with all privileges will be created.  The password will be randomly generated.
To get the password, check the logs of the container by running:

```
docker logs <CONTAINER_ID>
```

You should see an output like the following:

```
========================================================
CouchDB User: "couchdb"
CouchDB Password: "jPp5fBJySeuJPTN8"
========================================================
```

#### Credentials

If you want to preset credentials, you can also specify the `COUCHDB_PASSWORD` environment
variable.  Please note, the `COUCHDB_USERNAME` variable is required in this scenario, e.g.:

```
$ docker run -d \
    --name couchdb \
    -p 5984:5984 \
    -e COUCHDB_USERNAME=myusername \
    -e COUCHDB_PASSWORD=mypassword \
    kobretti/couchdb-cors
```

#### No admin user

If neither `COUCHDB_USERNAME` nor `COUCHDB_PASSWORD` are set when you create a container,
the administrator account will not be created.

#### Databases

If you want to create a database at container's boot time, you can set the `COUCHDB_DBNAME`
environment variable.  The database is going to be created even if the credentials have not been set.

In this example we will preset our custom username and password and we will create a database:

```
$ docker run -d \
    --name couchdb \
    -P \
    -e COUCHDB_USERNAME=myusername \
    -e COUCHDB_PASSWORD=mypassword \
    -e COUCHDB_DBNAME=mydb \
    kobretti/couchdb-cors
```

#### Persistent data

The CouchDB server is configured to store data in the `/usr/local/var/lib/couchdb/` directory
 inside the container. You can map this path to a volume on the host so the data becomes
 independent of the running container:

```
$ mkdir -p /tmp/couchdb
$ docker run -d \
    --name couchdb \
    -p 5984:5984 \
    -v /tmp/couchdb:/usr/local/var/lib/couchdb \
    kobretti/couchdb-cors
```

## Copyright

Copyright (c) 2014 Ferran Rodenas, 2015-2018 Krzysztof Kobrzak.
See [LICENCE](https://github.com/chris-kobrzak/docker-couchdb/blob/master/LICENCE) for details.

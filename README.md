# munin-server
Docker image with munin-server based on debian:stretch

## List of the nodes to check
The port is always optional, default is 4949

* NODES format: `name1:ip1[:port1] name2:ip2[:port2]` 
* SNMP_NODES format: `name1:ip1[:port1]`

## Port
Container is listening on the port 8080

## Volumes
Mount the following path:
* dbdir `/var/lib/munin`
* htmldir `/var/cache/munin/www`
* logdir `/var/log/munin`

## How to use the image

```
docker run -d -p 8080:8080 \
 -e NODES="service1.mydomain.com:192.168.0.1 service2.mydomain.com:192.168.0.2" \
 -v /host/munin/db:/var/lib/munin \
 -v /host/munin/www:/var/cache/munin/www \
 -v /host/munin/log:/var/log/munin \
 defank/munin-server
```

##### Docker-compose  service example

```
munin-server:
    image: defank/munin-server
    container_name: munin-server
    restart: always
    environment:
      - NODES=nginx.domain.com:10.38.33.12 memcached.domain.com:10.38.33.14
    volumes:
      - /host/munin/db:/var/lib/munin
      - /host/munin/log:/var/log/munin
      - /host/munin/www:/var/cache/munin/www
```

You can now reach your munin-server on port 8080 of your host. It will display at the first run:

Munin has not run yet. Please try again in a few moments.
Every 5 minutes munin-server will interrogate its nodes and build the graphs and store the data.
That's only after the first data fetching operation that the first graphs will appear.
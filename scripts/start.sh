#!/bin/bash

NODES=${NODES:-}
SNMP_NODES=${SNMP_NODES:-}

if [ ! -e /var/cache/munin/www/index.html ]; then
cat << EOF > /var/cache/munin/www/index.html
<html>
<head>
  <title>Munin</title>
</head>
<body>
Munin has not run yet.  Please try again in a few moments.
</body>
</html>
EOF
chown munin:munin -R /var/cache/munin/www
chmod g+w /var/cache/munin/www/index.html
fi

for NODE in $NODES
do
  NAME=`echo $NODE | cut -d ":" -f1`
  HOST=`echo $NODE | cut -d ":" -f2`
  PORT=`echo $NODE | cut -d ":" -f3`
  if [ ${#PORT} -eq 0 ]; then
      PORT=4949
  fi
  if ! grep -q $HOST /etc/munin/munin.conf ; then
    cat << EOF >> /etc/munin/munin.conf
[$NAME]
    address $HOST
    use_node_name yes
    port $PORT

EOF
    fi
done

# generate node list
for NODE in $SNMP_NODES
do
  NAME=`echo $NODE | cut -d ":" -f1`
  HOST=`echo $NODE | cut -d ":" -f2`
  PORT=`echo $NODE | cut -d ":" -f3`
  if [ ${#PORT} -eq 0 ]; then
      PORT=4949
  fi
  if ! grep -q $HOST /etc/munin/munin.conf ; then
    cat << EOF >> /etc/munin/munin.conf
[$NAME]
    address $HOST
    use_node_name no
    port $PORT

EOF
    fi
done

spawn-fcgi -s /var/run/munin/fcgi-graph.sock -U munin -u munin -g munin /usr/lib/munin/cgi/munin-cgi-graph

chown -R munin:munin /var/lib/munin
chown -R munin:munin /var/log/munin
chown -R munin:munin /var/cache/munin/www
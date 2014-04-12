#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}
$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

service sshd start
$HADOOP_PREFIX/sbin/start-dfs.sh
$HADOOP_PREFIX/sbin/start-yarn.sh

# knox bootstrap

mkdir -p /var/log/knox
java -jar $GATEWAY_HOME/bin/ldap.jar $GATEWAY_HOME/conf &>/var/log/knox/ldap.out &

cd $GATEWAY_HOME
mkdir -p conf/security
echo '#1.0#' > conf/security/master

# Make sure to read and understand the "Persisting the Master Secret" paragraph : http://knox.incubator.apache.org/books/knox-0-3-0/knox-0-3-0.html

echo 'UjFkVDZNS0N5Yzg9Ojp1WVNwREtFeG9KcHN1QjFYU1JDRkh3PT06OldTaUdOT1U5RUw0ejZ5SUM0VE5LMVE9PQ==' >> conf/security/master
bin/gateway.sh setup root
bin/gateway.sh start



if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi

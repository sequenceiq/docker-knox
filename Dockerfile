FROM sequenceiq/hadoop-docker
MAINTAINER SequenceIQ

# get unzip and knox-0.3.0-incubating
RUN yum install -y unzip
RUN mkdir /tmp/knox
RUN cd /tmp/knox && curl -o knox.zip http://www.eu.apache.org/dist/incubator/knox/0.3.0-incubating/knox-incubating-0.3.0-src.zip 
RUN cd /tmp/knox && unzip knox.zip -d /usr/local

# set knox gateway home, add to path
ENV KNOX_HOME /usr/local/knox
ENV PATH $PATH:$KNOX_HOME/bin

# start the embedded LDAP and the gatewat
RUN java -jar bin/ldap.jar conf &
RUN java -jar bin/gateway.jar

# bootstrap 
ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENV BOOTSTRAP /etc/bootstrap.sh

CMD ["/etc/bootstrap.sh", "-d"]

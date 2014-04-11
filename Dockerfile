FROM sequenceiq/hadoop-docker
MAINTAINER SequenceIQ

# get unzip and knox-0.3.0-incubating
RUN yum install -y unzip
RUN mkdir /tmp/knox
RUN cd /tmp/knox && curl -o knox-incubating-0.3.0.rpm http://xenia.sote.hu/ftp/mirrors/www.apache.org/incubator/knox/0.3.0-incubating/knox-incubating-0.3.0.rpm
RUN cd /tmp/knox && yum localinstall -y knox-incubating-0.3.0.rpm

# set knox gateway home, add to path
ENV GATEWAY_HOME /usr/lib/knox
ENV PATH $PATH:$GATEWAY_HOME/bin

# bootstrap-knox
ADD bootstrap-knox.sh /etc/bootstrap-knox.sh
RUN chown root:root /etc/bootstrap-knox.sh
RUN chmod 700 /etc/bootstrap-knox.sh

CMD ["/etc/bootstrap-knox.sh", "-bash"]

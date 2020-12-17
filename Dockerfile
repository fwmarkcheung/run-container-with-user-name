FROM registry.access.redhat.com/ubi8/ubi:8.1

# Install the basic requirements

#RUN yum -y update && yum -y install nss_wrapper && yum clean all
RUN yum -y install nss_wrapper gettext && yum clean all

COPY ./docker-entrypoint.sh ./
COPY ./passwd.template /var/tmp


USER 1001

ENTRYPOINT ["/bin/bash", "./docker-entrypoint.sh"]

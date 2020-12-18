FROM registry.access.redhat.com/ubi8/ubi:8.1


# User home directory
ENV USER_HOME=/usr/mark

# Install the tools and create user directory
RUN yum -y install nss_wrapper gettext && \
    yum clean all && \
    mkdir -p ${USER_HOME} && \
    chgrp -R 0 ${USER_HOME} && \
    chmod -R g+rwX ${USER_HOME}

COPY ./docker-entrypoint.sh ./
COPY ./passwd.template /var/tmp

USER 1001

ENTRYPOINT ["/bin/bash", "./docker-entrypoint.sh"]

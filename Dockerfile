FROM registry.access.redhat.com/ubi8/ubi:8.1


# User home directory
ENV USER_HOME=/usr/mark

# Install the tools and create user directory
RUN yum -y install nss_wrapper && \
    yum clean all && \
    mkdir -p ${USER_HOME}

COPY ./docker-entrypoint.sh ./passwd.template ${USER_HOME}

USER 1001

ENTRYPOINT ["/bin/bash", "${USER_HOME}/docker-entrypoint.sh"]

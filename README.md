Running an OCP container with a specific user name

When OpenShift starts a container, it uses an arbitrarily assigned user ID. This feature helps to ensure that if an application from within a container manages to break out to the host, it won’t be able to interact with other processes and containers owned by other users, in other projects.


If the process has requirements to alter file permissions or retrieve user information, then this security feature will cause problems for the container. For example, the container process needs to perform a whoami or look up it’s $HOME directory.

By default, OpenShift runs containers in a restricted SCC profile.  As a consequence, two system calls: SETUID and SETGID are blocked in the container. This means that containers running with the restricted SCC cannot use these system calls to change their UID or GID and escalate their privileges. 

There are two main solutions for containers which require to get user information include:

Rely on CRI-O or
Use nss_wrapper

The OpenShift run-time CRI-O (starting from OpenShift 4.2 onward) now inserts the random user for the container into /etc/passwd. Removing the requirement to insert the random user manually into /etc/passwd completely. Additionally in future versions of CRI-O, the $HOME or $WORKDIR of the container user will also be assigned, helping Java based images.


For containers deploying prior to OCP 4.2, nss_wrapper can be utilized. It provides a local, unprivileged passwd file which allows the container to map the required user information to a random UID without having to modify the containers /etc/passwd file directly.


To achieve this, the following script should be included as part of the startup script of the container.  It replaces the parameters with environment variables and creates a temporary unprivileged passwd file with the container’s user ID:



generate_passwd_file

function generate_passwd_file() {

 

  export USER_ID=$(id -u)

  export GROUP_ID=$(id -g)

 

  envsubst < /var/tmp/passwd.template > /tmp/passwd

  export LD_PRELOAD=/usr/lib64/libnss_wrapper.so

  export NSS_WRAPPER_PASSWD=/tmp/passwd

  export NSS_WRAPPER_GROUP=/etc/group

}


Where passwd.template contains:

passed.template

root:x:0:0:root:/root:/bin/bash

bin:x:1:1:bin:/bin:/sbin/nologin

daemon:x:2:2:daemon:/sbin:/sbin/nologin

adm:x:3:4:adm:/var/adm:/sbin/nologin

lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin

sync:x:5:0:sync:/sbin:/bin/sync

shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown

halt:x:7:0:halt:/sbin:/sbin/halt

mail:x:8:12:mail:/var/spool/mail:/sbin/nologin

operator:x:11:0:operator:/root:/sbin/nologin

games:x:12:100:games:/usr/games:/sbin/nologin

ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin

nobody:x:99:99:Nobody:/:/sbin/nologin

mark:x:${USER_ID}:${GROUP_ID}:mark container:${USER_HOME}:/bin/bash


To install the nss_wrapper and gettext (provides the envsubst command) package, include the following line in the Dockerfile:

Dockerfile Instruction

RUN yum -y install nss_wrapper gettext




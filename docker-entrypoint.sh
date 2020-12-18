#!/bin/bash

function generate_passwd_file() {

  export USER_ID=$(id -u)
  export GROUP_ID=$(id -g)

  envsubst < /var/tmp/passwd.template > /tmp/passwd
  export LD_PRELOAD=/usr/lib64/libnss_wrapper.so
  export NSS_WRAPPER_PASSWD=/tmp/passwd
  export NSS_WRAPPER_GROUP=/etc/group
}

generate_passwd_file

# Keep the container alive.  Otherwise, it will be in CrashLoopBackOff
while :
do
  echo "Press <CTRL+C> to exit."
  export USER_NAME=$(whoami)
  echo "I am ${USER_NAME}."
  getent passwd $USER_NAME
  sleep 10
done

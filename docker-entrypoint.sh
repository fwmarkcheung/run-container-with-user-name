#!/bin/bash

export HOME=/var/tmp

function generate_passwd_file() {

  export USER_ID=$(id -u)
  export GROUP_ID=$(id -g)

  echo "Adding a username: ${USER_NAME} to the /etc/passwd with the userid: ${USER_ID} and groupid: ${GROUP_ID}"

  envsubst < ${HOME}/passwd.template > /tmp/passwd
  export LD_PRELOAD=/usr/lib64/libnss_wrapper.so
  export NSS_WRAPPER_PASSWD=/tmp/passwd
  export NSS_WRAPPER_GROUP=/etc/group

}

generate_passwd_file

# Keep the container alive.  Otherwise, it will be in CrashLoopBackOff
while :
do
  echo "Press <CTRL+C> to exit."
  sleep 10
done

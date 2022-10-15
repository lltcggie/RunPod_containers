#!/bin/bash

echo "pod started"

if [[ $PUBLIC_KEY ]]
then
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    cd ~/.ssh
    echo $PUBLIC_KEY >> authorized_keys
    env | grep -v "^SHLVL=" | grep -v "^HOME=" | grep -v "^USER=" | grep -v "^LOGNAME=" | grep -v "^PWD=" | grep -v "^OLDPWD=" | \
        grep -v "^MAIL=" | grep -v "^TERM=" | grep -v "^SHELL=" | grep -v "^_=" | grep -v "^DEBIAN_FRONTEND=" \
        > /root/.ssh/environment
    chmod 700 -R ~/.ssh
    cd /
    echo PermitUserEnvironment yes >> /etc/ssh/sshd_config
    service ssh start
fi

if [[ $JUPYTER_PASSWORD ]]
then
    cd /
    jupyter notebook \
        --NotebookApp.allow_origin=* \
        --port=8888 \
        --NotebookApp.port_retries=0 \
        --NotebookApp.token=$JUPYTER_PASSWORD \
        --NotebookApp.notebook_dir=/workspace \
        --NotebookApp.terminado_settings='{"shell_command":["/bin/bash"]}' \
        --ip=* --no-browser --allow-root
else
    sleep infinity
fi

#!/bin/bash

echo "[Info]: Starting Node-reboot chaos..."

echo "PRIVATE_SSH_FILE_PATH: $PRIVATE_SSH_FILE_PATH"
echo "[Info]: Connection information, IP: ${IP}, USER: ${USER}, PORT: ${PORT}"

command="sleep 5 && sudo systemctl reboot"

if [ ! -z "$REBOOT_COMMAND" ]; then
    command="sleep 5 && $REBOOT_COMMAND"
fi

echo "[Info]: Chaos Command: ${command}"

if [ -z "$PRIVATE_SSH_FILE_PATH" ]; then

    sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USER}@${IP} -p ${PORT} -tt \
	"${command}"

else
    ssh -o StrictHostKeyChecking=no -i "$PRIVATE_SSH_FILE_PATH" ${USER}@${IP} "${command}" 
fi

echo "[Info]: Chaos Completed ..."
#!/bin/bash

set -e

echo "[Info]: Starting stress-ng process for Disk Fill chaos..."

echo "PRIVATE_SSH_FILE_PATH: $PRIVATE_SSH_FILE_PATH"
echo "[Info]: Connection information, IP: ${IP}, USER: ${USER}, PORT: ${PORT}"

command=""

if [ -z "$FILL_PERCENTAGE"]; then
    command="sudo stress-ng --fallocate ${NUMBER_OF_WORKERS} --fallocate-bytes ${FILL_PERCENTAGE}% --timeout ${TOTAL_CHAOS_DURATION}s --temp-path ${VOLUME_MOUNT_PATH}"
else
    command="sudo stress-ng --fallocate ${NUMBER_OF_WORKERS} --fallocate-bytes ${DISK_CONSUMPTION}g --timeout ${TOTAL_CHAOS_DURATION}s --temp-path ${VOLUME_MOUNT_PATH}"
fi

echo "[Info]: Chaos Command: ${command}"

if [ -z "$PRIVATE_SSH_FILE_PATH" ]; then

    sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USER}@${IP} -p ${PORT} -tt \
	"${command}"
    
else
    ssh -o StrictHostKeyChecking=no -i "$PRIVATE_SSH_FILE_PATH" ${USER}@${IP} "${command}" 
fi

echo "[Info]: Chaos Completed ..."
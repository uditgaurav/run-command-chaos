#!/bin/bash

set -e

echo "[Info]: Starting stress-ng process for Disk Fill chaos..."

echo "PRIVATE_SSH_FILE_PATH: $PRIVATE_SSH_FILE_PATH"
echo "[Info]: Connection information, IP: ${IP}, USER: ${USER}, PORT: ${PORT}"
echo "[Info]: Chaos Command: sudo stress-ng --fallocate ${NUMBER_OF_WORKERS} --fallocate-bytes ${FILL_PERCENTAGE}% --timeout ${TOTAL_CHAOS_DURATION}s --temp-path ${VOLUME_MOUNT_PATH}"

if [ -z "$PRIVATE_SSH_FILE_PATH" ]; then

    sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USER}@${IP} -p ${PORT} -tt \
	"sudo stress-ng --fallocate ${NUMBER_OF_WORKERS} --fallocate-bytes ${FILL_PERCENTAGE}% --timeout ${TOTAL_CHAOS_DURATION}s --temp-path ${VOLUME_MOUNT_PATH}"
    
else
    ssh -o StrictHostKeyChecking=no -i "$PRIVATE_SSH_FILE_PATH" ${USER}@${IP} "sudo stress-ng --fallocate ${NUMBER_OF_WORKERS} --fallocate-bytes ${FILL_PERCENTAGE}% --timeout ${TOTAL_CHAOS_DURATION}s --temp-path ${VOLUME_MOUNT_PATH}" 
fi

echo "[Info]: Chaos Completed ..."
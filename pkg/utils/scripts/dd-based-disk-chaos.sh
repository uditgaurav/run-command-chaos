#!/bin/bash

set -e

echo "[Info]: Starting dd process for Disk Fill chaos..."

echo "PRIVATE_SSH_FILE_PATH: $PRIVATE_SSH_FILE_PATH"
echo "[Info]: Connection information, IP: ${IP}, USER: ${USER}, PORT: ${PORT}"

command="sudo dd if=/dev/urandom of=${OUTPUT_FILE_PATH} bs=${BLOCK_SIZE}K count=${NUMBER_OF_BLOCKS}"

echo "[Info]: Chaos Command: ${command}"

if [ -z "$PRIVATE_SSH_FILE_PATH" ]; then

    sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USER}@${IP} -p ${PORT} -tt \
	"${command}"
    
else
    ssh -o StrictHostKeyChecking=no -i "$PRIVATE_SSH_FILE_PATH" ${USER}@${IP} "${command}" 
fi

echo "[Info]: Chaos Completed ..."
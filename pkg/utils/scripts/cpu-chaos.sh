#!/bin/bash

set -e

echo "[Info]: Starting stress-ng process for CPU chaos..."

echo "PRIVATE_SSH_FILE_PATH: $PRIVATE_SSH_FILE_PATH"
echo "[Info]: Connection information, IP: ${IP}, USER: ${USER}, PORT: ${PORT}"
echo "[Info]: Chaos Command: stress-ng --cpu ${CPU_CORES} --timeout ${TOTAL_CHAOS_DURATION}"

if [ -z "$PRIVATE_SSH_FILE_PATH" ]; then

    sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USER}@${IP} -p ${PORT} -tt \
	"stress-ng --cpu ${CPU_CORES} --timeout ${TOTAL_CHAOS_DURATION}"
    
else
    ssh -o StrictHostKeyChecking=no -i "$PRIVATE_SSH_FILE_PATH" ${USER}@${IP} "stress-ng --cpu ${CPU_CORES} --timeout ${TOTAL_CHAOS_DURATION}" 
fi

echo "[Info]: Chaos Completed ..."

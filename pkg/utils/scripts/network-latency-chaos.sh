#!/bin/bash

set -e

echo "[Info]: Starting Network Latency Chaos ..."

echo "PRIVATE_SSH_FILE_PATH: $PRIVATE_SSH_FILE_PATH"
echo "[Info]: Connection information, IP: ${IP}, USER: ${USER}, PORT: ${PORT}"

command="sudo tc qdisc replace dev ${NETWORK_INTERFACE} root netem delay ${NETWORK_LATENCY}ms ${JITTER}ms && sleep ${TOTAL_CHAOS_DURATION} && sudo tc qdisc delete dev ${NETWORK_INTERFACE} root"
echo "[Info]: Chaos Command: ${command}"

if [ -z "$PRIVATE_SSH_FILE_PATH" ]; then

    sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USER}@${IP} -p ${PORT} -tt \
	"${command}"
    
else
    ssh -o StrictHostKeyChecking=no -i "$PRIVATE_SSH_FILE_PATH" ${USER}@${IP} "${command}"
fi

echo "[Info]: Chaos Completed ..."

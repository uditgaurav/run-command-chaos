#!/bin/bash

set -e

echo "[Info]: Starting Network Loss Chaos ..."

echo "PRIVATE_SSH_FILE_PATH: $PRIVATE_SSH_FILE_PATH"
echo "[Info]: Connection information, IP: ${IP}, USER: ${USER}, PORT: ${PORT}"
echo "[Info]: Chaos Command: tc qdisc replace dev ${NETWORK_INTERFACE} root netem loss ${NETWORK_PACKET_LOSS_PERCENTAGE} && sleep ${TOTAL_CHAOS_DURATION} && tc qdisc delete dev ${NETWORK_INTERFACE} root"

if [ -z "$PRIVATE_SSH_FILE_PATH" ]; then

    sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USER}@${IP} -p ${PORT} -tt \
	"tc qdisc replace dev ${NETWORK_INTERFACE} root netem loss ${NETWORK_PACKET_LOSS_PERCENTAGE} && sleep ${TOTAL_CHAOS_DURATION} && tc qdisc delete dev ${NETWORK_INTERFACE} root"
    
else
    ssh -o StrictHostKeyChecking=no -i "$PRIVATE_SSH_FILE_PATH" ${USER}@${IP} "tc qdisc replace dev ${NETWORK_INTERFACE} root netem loss ${NETWORK_PACKET_LOSS_PERCENTAGE} && sleep ${TOTAL_CHAOS_DURATION} && tc qdisc delete dev ${NETWORK_INTERFACE} root" 
fi

echo "[Info]: Chaos Completed ..."

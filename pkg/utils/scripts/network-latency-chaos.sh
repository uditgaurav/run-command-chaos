#!/bin/bash

set -e

echo "[Info]: Starting Network Latency Chaos ..."

echo "PRIVATE_SSH_FILE_PATH: $PRIVATE_SSH_FILE_PATH"
echo "[Info]: Connection information, IP: ${IP}, USER: ${USER}, PORT: ${PORT}"

chaosCommand="sudo tc qdisc replace dev ${NETWORK_INTERFACE} root netem delay ${NETWORK_LATENCY}ms ${JITTER}ms"

if [ ! -z "$DESTINATION_IP" ]; then
    delayCommand="sudo tc qdisc replace dev ${NETWORK_INTERFACE} root handle 1: prio && sudo tc qdisc replace dev ${NETWORK_INTERFACE} parent 1:3 netem delay ${NETWORK_LATENCY}ms ${JITTER}ms"
    tc="sudo tc filter add dev ${NETWORK_INTERFACE} protocol ip parent 1:0 prio 3 u32 match ip dst ${DESTINATION_IP} flowid 1:3"

    chaosCommand="${delayCommand} && ${tc}"
fi

revertCommand="sudo tc qdisc delete dev ${NETWORK_INTERFACE} root"

command="${chaosCommand} && sleep ${TOTAL_CHAOS_DURATION} && ${revertCommand}"

echo "[Info]: Chaos Command: ${command}" 

if [ -z "$PRIVATE_SSH_FILE_PATH" ]; then

    sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USER}@${IP} -p ${PORT} -tt \
	"${command}"
    
else
    ssh -o StrictHostKeyChecking=no -i "$PRIVATE_SSH_FILE_PATH" ${USER}@${IP} "${command}"
fi

echo "[Info]: Chaos Completed ..."

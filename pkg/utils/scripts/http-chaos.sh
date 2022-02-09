#!/bin/bash

echo "[Info]: Starting httpchaos..."

echo "PRIVATE_SSH_FILE_PATH: $PRIVATE_SSH_FILE_PATH"
echo "[Info]: Connection information, IP: ${IP}, USER: ${USER}, PORT: ${PORT}"

echo "Starting toxiproxy server"
# Running toxiproxy server in background
toxiproxy-server > /dev/null 2>&1 &
sleep 2s

toxicCreateCommand="toxiproxy-cli create -l ${LISTEN_URL} --${STREAM_TYPE} ${STREAM_URL} service-down-toxic > /dev/null"
addToxicCommand="toxiproxy-cli toxic add -t down service-down-toxic > /dev/null && sleep ${TOTAL_CHAOS_DURATION}"
revertToxicCommand="toxiproxy-cli delete service-down-toxic && sudo kill -9 $(ps aux | grep [t]oxiproxy | awk '{print $2}')"

echo "[Info]: Chaos Command: ${toxicCreateCommand} && addToxicCommand && revertToxicCommand"

if [ -z "$PRIVATE_SSH_FILE_PATH" ]; then

    sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USER}@${IP} -p ${PORT} -tt \
	"${toxicCreateCommand} && ${addToxicCommand} && ${revertToxicCommand}"
    
else
    ssh -o StrictHostKeyChecking=no -i "$PRIVATE_SSH_FILE_PATH" ${USER}@${IP} "${toxicCreateCommand} && ${toxicAddCommand} && ${revertToxicCommand}" 
fi

echo "[Info]: Chaos Completed ..."
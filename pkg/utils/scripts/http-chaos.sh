#!/bin/bash

echo "[Info]: Starting httpchaos..."

echo "PRIVATE_SSH_FILE_PATH: $PRIVATE_SSH_FILE_PATH"
echo "[Info]: Connection information, IP: ${IP}, USER: ${USER}, PORT: ${PORT}"

startProxyServerCommand="toxiproxy-server > /dev/null 2>&1 &"
toxicCreateCommand="toxiproxy-cli create -l ${LISTEN_URL} --${STREAM_TYPE} ${STREAM_URL} service-down-toxic > /dev/null"
toggleToxicCommand="toxiproxy-cli toggle service-down-toxic > /dev/null && sleep ${TOTAL_CHAOS_DURATION}"
revertToxicCommand="toxiproxy-cli delete service-down-toxic"

echo "[Info]: Chaos Command: ${toxicCreateCommand} && ${toggleToxicCommand} && ${revertToxicCommand} && sudo kill -9 $(ps aux | grep [t]oxiproxy | awk '{print $2}')"

if [ -z "$PRIVATE_SSH_FILE_PATH" ]; then

    sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USER}@${IP} -p ${PORT} -tt \
	"${startProxyServerCommand} && sleep 2 && ${toxicCreateCommand} && ${toggleToxicCommand} && ${revertToxicCommand} && sudo kill -9 $(ps aux | grep [t]oxiproxy | awk '{print $2}')"
    
else
    ssh -o StrictHostKeyChecking=no -i "$PRIVATE_SSH_FILE_PATH" ${USER}@${IP} "${startProxyServerCommand} && sleep 2 && ${toxicCreateCommand} && ${toggleToxicCommand} && ${revertToxicCommand} && sudo kill -9 $(ps aux | grep [t]oxiproxy | awk '{print $2}')" 
fi

echo "[Info]: Chaos Completed ..."
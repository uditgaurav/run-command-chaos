#!/bin/bash

echo "[Info]: Starting httpchaos..."

echo "PRIVATE_SSH_FILE_PATH: $PRIVATE_SSH_FILE_PATH"
echo "[Info]: Connection information, IP: ${IP}, USER: ${USER}, PORT: ${PORT}"

startProxyServerCommand="(toxiproxy-server > /dev/null 2>&1 &) && sleep 2"
createProxyCommand="toxiproxy-cli create -l ${LISTEN_URL} --${STREAM_TYPE} ${STREAM_URL} proxy && sleep ${WAIT_BEFORE_ADDING_TOXIC}"

createToxicCommand="toxiproxy-cli toggle proxy && sleep ${TOTAL_CHAOS_DURATION}"

case $TOXIC_TYPE in

  toggle)
    createToxicCommand="toxiproxy-cli toggle proxy && sleep ${TOTAL_CHAOS_DURATION}"
    ;;

  reset_peer)
    createToxicCommand="toxiproxy-cli toxic add -t reset_peer -a timeout=${RESET_PEER_TIMEOUT} proxy && sleep ${TOTAL_CHAOS_DURATION}"
    ;;

  latency)
    createToxicCommand="toxiproxy-cli toxic add -t latency -a latency=${TOXIC_LATENCY} proxy && sleep ${TOTAL_CHAOS_DURATION}"
    ;;

  *)
    echo "Unknown TOXIC_TYPE given, Exiting..."
    exit 1
    ;;
esac

deleteProxyCommand="toxiproxy-cli delete proxy > /dev/null && sleep 5 && sudo kill -9 \$(ps aux | grep [t]oxiproxy | awk 'FNR==2{print \$2}')"

command="${startProxyServerCommand} && ${createProxyCommand} && ${createToxicCommand} && ${deleteProxyCommand}"

echo "[Info]: Chaos Command: ${command}"

if [ -z "$PRIVATE_SSH_FILE_PATH" ]; then

    sshpass -p "${PASSWORD}" ssh -o StrictHostKeyChecking=no "${USER}"@"${IP}" -p "${PORT}" "${command}"
    
else
    ssh -o StrictHostKeyChecking=no -i "$PRIVATE_SSH_FILE_PATH" "${USER}"@"${IP}" "${command}"
fi

echo "[Info]: Chaos Completed ..."
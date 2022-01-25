#!/bin/bash

set -e

echo "[Info]: Starting stress-ng process ..."
echo "[Info]: Chaos Command: stress-ng --cpu ${1} --timeout ${2}"

if [ -z "$PRIVATE_SSH_FILE" ]; then
    stress-ng --cpu ${1} --timeout ${2}
else
    stress-ng --cpu ${1} --timeout ${2}
fi

echo "[Info]: Chaos Completed ..."

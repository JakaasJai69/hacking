#!/bin/bash

# Usage: ./check_named_groups.sh <host> <port>

HOST=$1
PORT=$2

if [[ -z "$HOST" || -z "$PORT" ]]; then
    echo "Usage: $0 <host> <port>"
    exit 1
fi

# Common named groups (TLS 1.3 and 1.2)
NAMED_GROUPS=(
    x25519
    x448
    secp256r1
    secp384r1
    secp521r1
    ffdhe2048
    ffdhe3072
    ffdhe4096
)

echo "Checking supported named groups for $HOST:$PORT ..."
echo

for GROUP in "${NAMED_GROUPS[@]}"; do
    echo -n "Testing group $GROUP ... "

    # Attempt TLS 1.3 connection with only this group
    OUTPUT=$(echo | openssl s_client -groups "$GROUP" -connect "$HOST:$PORT" -tls1_3 2>/dev/null)

    # Check if handshake succeeded by finding server certificate
    if echo "$OUTPUT" | grep -q "-----BEGIN CERTIFICATE-----"; then
        echo "SUPPORTED"
    else
        echo "NOT SUPPORTED"
    fi
done

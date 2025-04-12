#!/bin/bash

# Usage: ./check_tls_ciphers.sh example.com 443

HOST=$1
PORT=$2

if [[ -z "$HOST" || -z "$PORT" ]]; then
    echo "Usage: $0 <host> <port>"
    exit 1
fi

echo "Checking supported cipher suites for $HOST:$PORT..."

CIPHERS=$(openssl ciphers 'ALL:eNULL' | tr ':' ' ')

for CIPHER in $CIPHERS; do
    echo -n "Testing $CIPHER ... "
    echo | openssl s_client -connect $HOST:$PORT -cipher $CIPHER -tls1_2 2>/dev/null | grep -q "Cipher is $CIPHER"
    if [ $? -eq 0 ]; then
        echo "SUPPORTED"
    else
        echo "NOT SUPPORTED"
    fi
done

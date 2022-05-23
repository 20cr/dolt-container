#!/bin/sh

_DOLT_BIN="/usr/local/bin/dolt"
_DOLT_DATA="/dolt/data"

if [ ! "$IDENTITY_NAME" ]; then
    echo "env identity name not set"
    exit 1
fi

if [ ! "$IDENTITY_EMAIL" ]; then
    echo "env identity email not set"
    exit 1
fi

if [ ! -d "$_DOLT_DATA" ]; then
    echo "Dolt data directory not found: $_DOLT_DATA" 
    exit 1
else
    cd "$_DOLT_DATA" || return
fi

if ! dolt status 2> /dev/null; then
    "$_DOLT_BIN" init --name "$IDENTITY_NAME" --email "$IDENTITY_EMAIL"
fi

"$_DOLT_BIN" version
"$_DOLT_BIN" sql-server --config /dolt/config.yaml

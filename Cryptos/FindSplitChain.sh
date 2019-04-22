#!/bin/bash

min() {
    printf "%s\n" "${@:2}" | sort "$1" | head -n1
}

max() {
    # using sort's -r (reverse) option - using tail instead of head is also possible
    min ${1}r ${@:2}
}

CLI="/usr/local/bin/blastx-cli -conf=/home/miner/.blastx01/blastx.conf"
CLI_GETBLOCKHASH="${CLI} getblockhash"
CLI_GETBLOCKCOUNT="${CLI} getblockcount"

API="http://explorer.blastexchange.com/api"
API_GETBLOCKHASH="${API}/getblockhash?index="
API_GETBLOCKCOUNT="${API}/getblockcount"

CLI_COUNT=$( $CLI_GETBLOCKCOUNT )
API_COUNT=$( $API_GETBLOCKCOUNT )

START_BLOCK=$( min -g $CLI_COUNT $API_COUNT )

echo "CLI Count = ${CLI_COUNT}"
echo "API Count = ${API_COUNT}"
echo "Start Block = ${START_BLOCK}"

#!/bin/bash

min() {
    printf "%s\n" "${@:2}" | sort "$1" | head -n1
}

CLI="/usr/local/bin/blastx-cli -conf=/home/miner/.blastx03/blastx.conf"
CLI_GETBLOCKHASH="${CLI} getblockhash"
CLI_GETBLOCKCOUNT="${CLI} getblockcount"

CURL="/usr/bin/curl --silent"
API="${CURL} http://explorer.blastexchange.com/api"
API_GETBLOCKHASH="${API}/getblockhash?index="
API_GETBLOCKCOUNT="${API}/getblockcount"

CLI_COUNT=$( $CLI_GETBLOCKCOUNT )
API_COUNT=$( $API_GETBLOCKCOUNT )

START_BLOCK=$( min -g $CLI_COUNT $API_COUNT )
BLOCK=$START_BLOCK
END_BLOCK=1

#echo "CLI Count = ${CLI_COUNT}"
#echo "API Count = ${API_COUNT}"
#echo "Start Block = ${START_BLOCK}"
#echo ""

SPLITTED=0

while [ $BLOCK -gt $END_BLOCK ]
do
	CLI_HASH=$( ${CLI_GETBLOCKHASH} ${BLOCK} )
	API_HASH=$( ${API_GETBLOCKHASH}${BLOCK} )
	#API_HASH=$( ${API_GETBLOCKHASH}69180 )	# script debug

	echo "#${BLOCK} ${CLI_HASH} ${API_HASH}"

	if [ $CLI_HASH == $API_HASH ]
	then
		break
	fi

	SPLITTED=1

	((BLOCK--))
done

echo ""

if [ $SPLITTED == 1 ]
then
	BAD_BLOCK=$(($BLOCK + 1))
	BAD_HASH=$( ${CLI_GETBLOCKHASH} ${BAD_BLOCK} )
	
	echo "SPLIT CHAIN FOUND AT BLOCK # ${BAD_BLOCK} = ${BAD_HASH}"
	exit 1
else
	echo "No split chain found"
	exit 0
fi

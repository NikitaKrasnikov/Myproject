#!/bin/bash
[ -z "$1" ] && echo "Usage: $0 <message>" && exit 1
BOT_TOKEN="YOUR_BOT_TOKEN"
CHAT_ID="YOUR_CHAT_ID"
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
     -d chat_id="$CHAT_ID" -d text="$1" > /dev/null
echo "Message sent: $1"


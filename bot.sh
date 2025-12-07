#!/bin/bash
TOKEN="8435850926:AAGx4NbYB-20gZBS_LzEhtpaKbFD3nPAie8"
URL="https://api.telegram.org/bot$TOKEN"
UPDATE_ID=0

echo "Бот запущен. Token: $TOKEN"

while true; do
    UPDATES=$(curl -s "$URL/getUpdates?offset=$((UPDATE_ID+1))")
    echo "Получены обновления: $UPDATES"
    
    MSG=$(echo "$UPDATES" | grep -o '"text":"[^"]*"' | cut -d'"' -f4)
    CHAT=$(echo "$UPDATES" | grep -o '"chat":{"id":[^,]*' | cut -d: -f3)
    NEW_ID=$(echo "$UPDATES" | grep -o '"update_id":[^,]*' | cut -d: -f2 | head -1)
    
    echo "Сообщение: $MSG, Чат: $CHAT, ID: $NEW_ID"
    
    if [ -n "$NEW_ID" ] && [ "$NEW_ID" -gt "$UPDATE_ID" ]; then
        UPDATE_ID=$NEW_ID
        echo "Обрабатываю команду: $MSG"
        case $MSG in
            "Дата"|"дата"|"/date") 
                curl -s -X POST "$URL/sendMessage" -d "chat_id=$CHAT" -d "text=$(date +%d.%m.%Y)"
                echo "Отправлена дата"
                ;;
        esac
    fi
    sleep 1
done

#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Ошибка: необходимо передать один аргумент - имя файла с данными"
    echo "Пример использования: ./analyze_sales.sh sales.txt"
    exit 1
fi

INPUT_FILE="$1"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Ошибка: файл '$INPUT_FILE' не существует"
    exit 1
fi

if [ ! -s "$INPUT_FILE" ]; then
    echo "Ошибка: файл '$INPUT_FILE' пустой"
    exit 1
fi

if [ ! -r "$INPUT_FILE" ]; then
    echo "Ошибка: нет прав на чтение файла '$INPUT_FILE'"
    exit 1
fi

TOTAL_SUM=0
declare -A DAY_SALES
declare -A PRODUCT_COUNT
declare -A PRODUCT_SUM

while IFS=' ' read -r DATE DAY PRODUCT PRICE QUANTITY; do
    if [ -z "$DATE" ] || [ -z "$DAY" ] || [ -z "$PRODUCT" ] || [ -z "$PRICE" ] || [ -z "$QUANTITY" ]; then
        continue
    fi
    
    if ! [[ "$PRICE" =~ ^[0-9]+(\.[0-9]+)?$ ]] || ! [[ "$QUANTITY" =~ ^[0-9]+$ ]]; then
        continue
    fi
    
    LINE_SUM=$(echo "$PRICE * $QUANTITY" | bc -l)
    TOTAL_SUM=$(echo "$TOTAL_SUM + $LINE_SUM" | bc -l)
    
    DAY_KEY="$DATE $DAY"
    if [ -z "${DAY_SALES[$DAY_KEY]}" ]; then
        DAY_SALES["$DAY_KEY"]=0
    fi
    DAY_SALES["$DAY_KEY"]=$(echo "${DAY_SALES[$DAY_KEY]} + $LINE_SUM" | bc -l)
    
    if [ -z "${PRODUCT_COUNT[$PRODUCT]}" ]; then
        PRODUCT_COUNT["$PRODUCT"]=0
    fi
    PRODUCT_COUNT["$PRODUCT"]=$((PRODUCT_COUNT[$PRODUCT] + QUANTITY))
    
    if [ -z "${PRODUCT_SUM[$PRODUCT]}" ]; then
        PRODUCT_SUM["$PRODUCT"]=0
    fi
    PRODUCT_SUM["$PRODUCT"]=$(echo "${PRODUCT_SUM[$PRODUCT]} + $LINE_SUM" | bc -l)
    
done < "$INPUT_FILE"

echo "Общая сумма продаж: $(printf "%.2f" $TOTAL_SUM)"

MAX_DAY_SUM=0
MAX_DAY_KEY=""

for DAY_KEY in "${!DAY_SALES[@]}"; do
    DAY_SUM=${DAY_SALES[$DAY_KEY]}
    if (( $(echo "$DAY_SUM > $MAX_DAY_SUM" | bc -l) )); then
        MAX_DAY_SUM=$DAY_SUM
        MAX_DAY_KEY=$DAY_KEY
    fi
done

if [ -n "$MAX_DAY_KEY" ]; then
    FORMATTED_SUM=$(printf "%.2f" $MAX_DAY_SUM)
    echo "День с наибольшей выручкой: $MAX_DAY_KEY (сумма продаж: $FORMATTED_SUM)"
fi

MAX_PRODUCT_COUNT=0
POPULAR_PRODUCT=""

for PRODUCT in "${!PRODUCT_COUNT[@]}"; do
    COUNT=${PRODUCT_COUNT[$PRODUCT]}
    if [ $COUNT -gt $MAX_PRODUCT_COUNT ]; then
        MAX_PRODUCT_COUNT=$COUNT
        POPULAR_PRODUCT=$PRODUCT
    fi
done

if [ -n "$POPULAR_PRODUCT" ]; then
    POPULAR_PRODUCT_SUM=${PRODUCT_SUM[$POPULAR_PRODUCT]}
    FORMATTED_PRODUCT_SUM=$(printf "%.2f" $POPULAR_PRODUCT_SUM)
    echo "Популярный товар: $POPULAR_PRODUCT (количество проданных единиц: $MAX_PRODUCT_COUNT, сумма продаж: $FORMATTED_PRODUCT_SUM)"
fi

#!/bin/bash

echo "Введите путь к файлу:"
read file_path

# Проверяем существует ли файл
if [ ! -f "$file_path" ]; then
    echo "Ошибка: Файл не существует!"
    exit 1
fi

# Подсчитываем количество строк
line_count=$(wc -l < "$file_path")

echo "Количество строк в файле: $line_count"

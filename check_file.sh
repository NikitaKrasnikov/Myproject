#!/bin/bash

echo "Введите путь к файлу:"
read file_path

if [ -f "$file_path" ]; then
    echo "Файл найден!"
else
    echo "Файл не найден."
fi

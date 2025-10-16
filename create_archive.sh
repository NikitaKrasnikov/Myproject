#!/bin/bash

echo "Введите путь к директории для архивации:"
read directory_path

# Проверяем существует ли директория
if [ ! -d "$directory_path" ]; then
    echo "Ошибка: Директория не существует!"
    exit 1
fi

# Получаем текущую дату
current_date=$(date +"%Y-%m-%d_%H-%M-%S")

# Создаем имя архива с датой
archive_name="backup_$(basename "$directory_path")_${current_date}.tar.gz"

# Создаем архив
tar -czf "$archive_name" -C "$(dirname "$directory_path")" "$(basename "$directory_path")"

echo "Архив создан: $archive_name"

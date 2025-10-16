#!/bin/bash

echo "Введите путь к директории:"
read directory_path

# Проверяем существует ли директория
if [ ! -d "$directory_path" ]; then
    echo "Ошибка: Директория не существует!"
    exit 1
fi

# Переходим в директорию
cd "$directory_path" || exit 1

# Добавляем префикс backup_ ко всем файлам (кроме скрытых)
for file in *; do
    if [ -f "$file" ]; then
        mv "$file" "backup_$file"
        echo "Переименован: $file → backup_$file"
    fi
done

echo "Готово! Префикс backup_ добавлен ко всем файлам."


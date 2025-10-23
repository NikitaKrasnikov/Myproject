#!/bin/bash

echo "Поиск 5 самых старых log-файлов..."

# Найти все файлы логов и отсортировать по времени создания
echo "Список 5 самых старых файлов:"
find . -name "*.log" -type f -printf "%T@ %p\n" | sort -n | head -5 | cut -d' ' -f2-

echo ""
echo "Подробная информация с датами:"
find . -name "*.log" -type f -printf "%TY-%Tm-%Td %TH:%TM:%TS %p\n" | sort -n | head -5

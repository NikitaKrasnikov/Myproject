#!/bin/bash

echo "Введите ваше имя:"
read name

echo "Введите ваш возраст:"
read age

next_age=$((age + 1))

echo "Привет, $name! Через год тебе будет $next_age лет."

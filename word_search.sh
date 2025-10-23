#!/bin/bash
[ $# -ne 2 ] && echo "Usage: $0 <file> <word>" && exit 1
[ ! -f "$1" ] && echo "File not found" && exit 1
grep -o -i -w "$2" "$1" | wc -l

#!/bin/bash
[ $# -ne 2 ] && echo "Usage: $0 <file> <word>" && exit 1
grep -o -w "$2" "$1" | wc -l


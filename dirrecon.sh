#!/bin/bash

ReconFolders(){
    base="$1"
    wordlist="$2"

    # FIX: while read em vez de for+cat (evita quebrar em espaços)
    while IFS= read -r word; do
        [[ -z "$word" ]] && continue
        code=$(curl -s -H "User-Agent: Hiro_tool" -o /dev/null -w "%{http_code}\n" "$base/$word/")

        if [ "$code" -eq 200 ]; then
            echo "Diretorio encontrado → $base/$word/"
        fi
    done < "$wordlist"
}

####################################################

ReconFiles(){
    base="$1"
    wordlist="$2"

    # FIX: while read em vez de for+cat
    while IFS= read -r word; do
        [[ -z "$word" ]] && continue
        code=$(curl -s -H "User-Agent: Hiro_tool" -o /dev/null -w "%{http_code}\n" "$base/$word")

        if [ "$code" -eq 200 ]; then
            echo "Arquivo encontrado → $base/$word"
        fi
    done < "$wordlist"
}

####################################################

ReconFolders "$1" "$2"

echo "============================================================="

# FIX: chamada que estava faltando
ReconFiles "$1" "$2"

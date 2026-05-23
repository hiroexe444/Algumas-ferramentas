#!/bin/bash
# Modo de uso:
# ./dnsrecon.sh www.exemplo.com wordlist.txt

# FIX: validação de argumentos e dependências
if [ $# -ne 2 ]; then
    echo "Modo de uso: $0 <dominio> <wordlist>"
    exit 1
fi

if [ ! -f "$2" ]; then
    echo "Erro: wordlist '$2' não encontrada."
    exit 1
fi

if ! command -v host &> /dev/null; then
    echo "Erro: comando 'host' não instalado. Instale o bind9-host."
    exit 1
fi

# FIX: while read em vez de for+cat (evita quebrar em espaços/nomes especiais)
while IFS= read -r sub; do
    [[ -z "$sub" ]] && continue
    host "$sub.$1" | grep -v "NXDOMAIN"
done < "$2"

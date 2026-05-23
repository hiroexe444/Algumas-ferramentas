#!/bin/bash
# Port knock script using nmap. Requests multiple ports as variables.
# FIX: envia uma porta por vez com delay para garantir ordem exata do knock
# (nmap pode reordenar pacotes internamente, quebrando a sequência)

if [ $# -ne 4 ]; then
  echo "Usage: $0 host port1 port2 port3"
  echo "Ports will be knocked in order: port1 → port2 → port3"
  exit;
fi

ports=($2 $3 $4)
host=$1

echo "You are knocking on ports:"
echo
printf "%s\n" "${ports[@]}"
echo
echo

# FIX: um nmap por porta, em sequência, com sleep entre eles
# Garante a ordem correta do port knocking
for port in "${ports[@]}"; do
    nmap -Pn -p "$port" "$host" > /dev/null 2>&1
    sleep 0.5
done

echo "Knock sequence done: ${ports[0]} → ${ports[1]} → ${ports[2]}"
echo

# Scan de portas abertas após o knock
echo "Current open Ports"
echo
nmap -Pn -p0-5000 "$host" | awk '/open/'

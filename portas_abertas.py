#!/usr/bin/python3
import subprocess
import sys

def verificar_portas():
    print("Verificando portas abertas...")

    # FIX: tenta ss primeiro (moderno), cai para netstat se não tiver
    if subprocess.run(["which", "ss"], capture_output=True).returncode == 0:
        cmd = ["sudo", "ss", "-nltp"]
    elif subprocess.run(["which", "netstat"], capture_output=True).returncode == 0:
        cmd = ["sudo", "netstat", "-nltp"]
    else:
        print("Erro: nem 'ss' nem 'netstat' encontrados no sistema.")
        sys.exit(1)

    # FIX: usa subprocess em vez de os.system para capturar e tratar a saída
    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode != 0:
        print(f"Erro ao executar comando (precisa de sudo?): {result.stderr.strip()}")
        sys.exit(1)

    for line in result.stdout.splitlines():
        # extrai a porta local da linha
        parts = line.split()
        for part in parts:
            if ':' in part:
                porta = part.split(':')[-1]
                if porta.isdigit():
                    print(porta)
                    break

verificar_portas()

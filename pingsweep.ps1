# By Hiro
# FIX: script é específico para Windows (ping -n e "bytes=32" são do cmd do Windows)
# Para Linux/Mac use: for i in $(seq 1 254); do ping -c 1 -W 1 "$ip.$i" | grep "bytes from"; done

param ($ip)
if (!$ip){

    echo "By Hiro"
    echo "Modo de uso:"
    echo "./pingsweep.ps1 8.8.8."

}else{
    foreach ($ip2 in 1..254){
        try {
            # FIX: captura a saída corretamente e filtra "TTL=" (mais robusto que "bytes=32")
            $resp = ping -n 1 "$ip.$ip2" | Select-String "TTL="
            if ($resp) {
                $resp.Line.Split(' ')[2] -replace ":",""
            }
        } catch {}
    }
}

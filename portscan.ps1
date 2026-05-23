# By Hiro - Portscan
# FIX: scan completo agora roda em paralelo (jobs) para não levar horas

param ($alvo, $selectPort)

if (!$alvo){
    Echo "Como Usar:"
    Echo ".\portscan.ps1 www.site.com"
    Echo ".\portscan.ps1 www.site.com 80"
    exit
}

# Porta específica: comportamento original mantido
if ($selectPort){
    $result = Test-NetConnection -ComputerName $alvo -Port $selectPort -WarningAction SilentlyContinue
    
    if ($result.TcpTestSucceeded){
        Write-Host "Porta $selectPort aberta!"
    } else {
        Write-Host "Porta $selectPort fechada."
    }
    exit
}

# FIX: scan completo em paralelo usando Start-Job (lotes de 50 portas)
Write-Host "Iniciando scan completo em $alvo (paralelizado)..."

$jobs = @()
$batchSize = 50

for ($start = 1; $start -le 65535; $start += $batchSize) {
    $end = [math]::Min($start + $batchSize - 1, 65535)
    $jobs += Start-Job -ScriptBlock {
        param($host_, $s, $e)
        foreach ($port in $s..$e) {
            $r = Test-NetConnection -ComputerName $host_ -Port $port -WarningAction SilentlyContinue
            if ($r.TcpTestSucceeded) {
                Write-Output "Porta $port aberta!"
            }
        }
    } -ArgumentList $alvo, $start, $end
}

# Aguarda todos os jobs e exibe resultados
$jobs | Wait-Job | Receive-Job
$jobs | Remove-Job

# By Hiro - Portscan
# 16/11/2025
